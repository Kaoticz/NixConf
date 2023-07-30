{ lib, config, ... }:
let
  cfg = config.kotz.themes.gtk;
  darkModeValue = if cfg.darkMode then "1" else "0";
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.themes.gtk = {
    enable = lib.mkEnableOption "Kotz's GTK configuration.";
    darkMode = lib.mkEnableOption "Whether to enable dark mode, if available.";
    themeName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "";
      description = lib.mdDoc "The name of the theme within the package.";
    };
    themePackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = lib.mdDoc ''
        The package for the theme. This installs the package to your environment.
        Set to null if the package is already available in your environment.
      '';
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    gtk.enable = cfg.enable;
    gtk.theme.name = cfg.themeName;
    gtk.theme.package = cfg.themePackage;
    gtk.gtk3.extraConfig.Settings = "gtk-application-prefer-dark-theme=${darkModeValue}";
    gtk.gtk4.extraConfig.Settings = "gtk-application-prefer-dark-theme=${darkModeValue}";
    home.sessionVariables.GTK_THEME = cfg.themeName;
  };
}
