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
    enableDisplayManager = lib.mkEnableOption "Enables Pantheon's default display manager.";
    autoLoginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc "The user to automatically log on as.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Enable X11
    kotz.graphics.x11.enable = true;
    kotz.graphics.x11.autoLoginUser = cfg.autoLoginUser;

    # Enable the Pantheon Desktop Environment.
    services.xserver.displayManager.lightdm.enable = cfg.enableDisplayManager;
    services.xserver.displayManager.lightdm.greeters.pantheon.enable = cfg.enableDisplayManager;
    services.xserver.desktopManager.pantheon.enable = true;

    # Enable Pantheon Tweaks.
    programs.pantheon-tweaks.enable = true;

    # Add XDG Portals
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    # Add extra packages.
    environment.systemPackages = with pkgs; [
      appeditor
      baobab
      gnome.gnome-calculator
      gnome.gnome-clocks
      monitor
      transmission_4-gtk
      whitesur-gtk-theme
    ];

    # Exclude some Pantheon packages.
    environment.pantheon.excludePackages = with pkgs; [
      pantheon.epiphany
      pantheon.elementary-tasks
      pantheon.elementary-calculator
      pantheon.elementary-mail
      pantheon.elementary-music
      pantheon.elementary-videos
      pantheon.elementary-feedback
      pantheon.elementary-calendar
      pantheon.elementary-onboarding
    ];
  };
}
