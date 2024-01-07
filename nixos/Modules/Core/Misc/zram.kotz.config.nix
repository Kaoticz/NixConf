{ lib, config, ... }:
let
  cfg = config.kotz.zram;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.zram = {
    enable = lib.mkEnableOption "Kotz's zram configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    zramSwap.enable = true;
    zramSwap.memoryPercent = 75;
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
