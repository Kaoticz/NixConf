{ lib, config, ... }:
let
  cfg = config.kotz.boot.grub;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.boot.grub = {
    enable = lib.mkEnableOption "Kotz's Grub configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = true;
  };
}
