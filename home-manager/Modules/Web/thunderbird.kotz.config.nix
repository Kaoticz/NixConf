{ pkgs, lib, config, ... }:
let
  cfg = config.kotz.thunderbird;
  settingsFactory = import ./Settings/thunderbird.settings.nix;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.thunderbird = {
    enable = lib.mkEnableOption "Kotz's Thunderbird configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Install Betterbird
    programs.thunderbird.enable = true;
    #programs.thunderbird.package = pkgs.betterbird;

    # Profile settings
    programs.thunderbird.profiles.${config.home.username} = {
      isDefault = true;
      withExternalGnupg = true;
      settings = settingsFactory config;
    };
  };
}
