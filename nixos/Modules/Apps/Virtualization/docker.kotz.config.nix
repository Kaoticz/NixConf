{ lib, config, pkgs, ... }:
let
  cfg = config.kotz.virtualization.docker;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.virtualization.docker = {
    enable = lib.mkEnableOption "Kotz's Docker configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.rootless.enable = true;
    virtualisation.docker.rootless.setSocketVariable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
