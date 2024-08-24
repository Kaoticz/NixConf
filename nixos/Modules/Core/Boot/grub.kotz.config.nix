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
    boot.loader.timeout = 3;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = builtins.pathExists "/sys/firmware/efi";
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;
  };
}
