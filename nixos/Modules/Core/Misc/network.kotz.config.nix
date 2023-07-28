{ lib, config, ... }:
let
  cfg = config.kotz.networking;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.networking = {
    enable = lib.mkEnableOption "Kotz's networking configuration.";
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = lib.mdDoc "The name of this computer.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    networking.hostName = cfg.hostName; # Define your hostname.
    networking.networkmanager.enable = true; # Enable networking
    networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}
