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

    # Define DNS settings.
    ## DNSCrypt creates a local DNS server at "127.0.0.1" and "::1",
    ## so set these addresses as the default DNS servers for the whole OS
    ## and don't let NetworkManager change them.
    services.resolved.enable = false;
    networking.networkmanager.dns = "none";
    networking.nameservers = [
      "127.0.0.1"
      "::1"
    ];

    # Set up DNSCrypt
    systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = "dnscrypt-proxy";
    services.dnscrypt-proxy2.enable = true;
    services.dnscrypt-proxy2.settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers.cache_file = "public-resolvers.md";
      sources.public-resolvers.minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      sources.public-resolvers.urls = [
        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
      ];

      # Choose a specific set of servers from:
      # https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        "dns0-unfiltered"
      ];
    };

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
