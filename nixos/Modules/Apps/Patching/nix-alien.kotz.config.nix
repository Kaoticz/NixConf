{ lib, config, ... }:
let
  cfg = config.kotz.patching.nix-alien;
  nix-alien-pkgs = (import
    (builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master")
  ) { };
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.patching.nix-alien = {
    enable = lib.mkEnableOption "Kotz's nix-alien configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with nix-alien-pkgs; [
      nix-alien
    ];

    programs.nix-ld.enable = true;
  };
}
