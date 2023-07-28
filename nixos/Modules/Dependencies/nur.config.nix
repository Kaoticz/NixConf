{ lib, config, ... }:
let
  cfg = config.kotz.nur;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.nur = {
    enable = lib.mkEnableOption "Enable the Nix User Repository.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
    };
  };
}
