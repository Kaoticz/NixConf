{ lib, config, pkgs, ... }:
let
  cfg = config.kotz.graphics.de.pantheon;
in
{
  # Imports: extra modules this module uses.
  imports = [
    ../X11.kotz.config.nix
  ];

  # Options: settings the user can change.
  options.kotz.graphics.de.pantheon = {
    enable = lib.mkEnableOption "Kotz's Pantheon DE configuration.";
    autoLoginUser = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The user to automatically log on as.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Enable X11
    kotz.graphics.x11.enable = true;
    kotz.graphics.x11.autoLoginUser = cfg.autoLoginUser;

    # Enable the Pantheon Desktop Environment.
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.pantheon.enable = true;

    # Enable Pantheon Tweaks.
    programs.pantheon-tweaks.enable = true;

    # Add extra packages.
    environment.systemPackages = with pkgs; [
      whitesur-gtk-theme
      gnome.gnome-system-monitor
      gnome.gnome-calculator
    ];

    # Exclude some Pantheon packages.
    environment.pantheon.excludePackages = with pkgs; [
      pantheon.epiphany
      pantheon.elementary-tasks
      pantheon.elementary-camera
      pantheon.elementary-calculator
    ];
  };
}
