{ lib, config, pkgs, ... }:
let
  cfg = config.kotz.graphics.x11;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.graphics.x11 = {
    enable = lib.mkEnableOption "Kotz's X11 configuration.";
    autoLoginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc "The user to automatically log on as.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "br";
      variant = "";
    };

    # Add extra packages.
    environment.systemPackages = with pkgs; [
      xorg.xhost
    ];

    # Enable touchpad support (enabled by default in most desktop managers).
    services.libinput.enable = true;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = cfg.autoLoginUser != null;
    services.displayManager.autoLogin.user = cfg.autoLoginUser;
  };
}
