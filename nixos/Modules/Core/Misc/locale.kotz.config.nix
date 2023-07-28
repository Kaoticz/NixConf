{ lib, config, ... }:
let
  cfg = config.kotz.locale;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.locale = {
    enable = lib.mkEnableOption "Kotz's locale configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    time.timeZone = "America/Sao_Paulo"; # Set your time zone.
    console.keyMap = "br-abnt2"; # Configure console keymap

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };
}
