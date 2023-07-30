{ lib, config, options, ... }:
let
  cfg = config.kotz.themes.gtk;
  darkModeValue = if cfg.darkMode then "1" else "0";
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.themes.gtk = options.gtk // {
    # "Inherit" all options in 'gtk'
    darkMode = lib.mkEnableOption "Whether to enable dark mode, if available.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    home.sessionVariables.GTK_THEME = cfg.theme.name;
    gtk.gtk2.extraConfig.Settings = "gtk-application-prefer-dark-theme=${darkModeValue}";
    gtk.gtk3.extraConfig.Settings = "gtk-application-prefer-dark-theme=${darkModeValue}";
    gtk.gtk4.extraConfig.Settings = "gtk-application-prefer-dark-theme=${darkModeValue}";
  };
}
