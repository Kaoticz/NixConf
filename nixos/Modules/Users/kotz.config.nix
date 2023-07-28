{ lib, config, ... }:
let
  cfg = config.kotz.user;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.user = {
    enable = lib.mkEnableOption "Kotz's user configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    users.users.kotz.isNormalUser = true;
    users.users.kotz.description = "Kotz";
    users.users.kotz.extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
