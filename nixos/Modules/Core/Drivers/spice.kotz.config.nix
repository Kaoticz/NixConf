{ lib, config, ... }:
let
  cfg = config.kotz.drivers.spice;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.drivers.spice = {
    enable = lib.mkEnableOption "Kotz's Spice-Vdagent configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
  };
}
