{ lib, config, pkgs, ... }:
let
  cfg = config.kotz.bash;
  bleshBashrcFactory = import ./Settings/bash.blesh.settings.nix;
  supportedEnvs = {
    none = { aliases = { }; bashrc = ""; };
    gnome = import ./Settings/bash.gnome.settings.nix;
    pantheon = import ./Settings/bash.pantheon.settings.nix { inherit pkgs; };
  };
  baseAliases = {
    nixlist = "nix-store -q --references /run/current-system/sw | grep -oP '^\/nix\/store\/[a-zA-Z0-9]+\-\K(.*)$'";
    nixgenlist = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    nixgenclean = "sudo nix-collect-garbage -d && echo -e '\nUse homegenlist to list generations and homegenclean <ids> to delete one or multiple generations.\n'";
    homelist = "home-manager packages";
    homegenlist = "home-manager generations";
    homegenclean = "home-manager remove-generations";
    update-root = "sudo nix-channel --update && sudo nixos-rebuild switch";
    update-home = "nix-channel --update && home-manager switch";
    update = "update-root && update-home";
    #inithost = "sudo mkdir -p /mnt/host && sudo mount -t virtiofs host-fs /mnt/host";
  };
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.bash = {
    enable = lib.mkEnableOption "Kotz's Bash configuration.";
    enableBlesh = lib.mkEnableOption "Enable ble.sh command line editor.";
    enableAliases = lib.mkEnableOption "Enable Kotz's default aliases.";
    environment = lib.mkOption {
      type = lib.types.str;
      default = "none";
      description = lib.mdDoc "The environments supported by this module.";
    };
    bashrc = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = lib.mdDoc "Extra code to be called after environment's bashrc code.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Install packages
    home.packages = with pkgs;
      if cfg.enableBlesh
      then [ eza blesh ]
      else
        if cfg.enableAliases
        then [ eza ]
        else [ ];

    # Setup Bash
    programs.bash.enable = true;
    programs.bash.enableCompletion = true;

    # Setup aliases
    programs.bash.shellAliases =
      if !(cfg.enableAliases)
      then { }
      else
        if supportedEnvs ? ${cfg.environment}
        then baseAliases // supportedEnvs.${cfg.environment}.aliases
        else baseAliases;

    # Setup bashrc
    programs.bash.initExtra =
      if !(supportedEnvs ? ${cfg.environment})
      then throw "kotz.bash.environment: Invalid value '${cfg.environment}'."
      else
        if cfg.enableBlesh
        then bleshBashrcFactory { inherit pkgs; bashrc = supportedEnvs.${cfg.environment}.bashrc + "\n" + cfg.bashrc; }
        else supportedEnvs.${cfg.environment}.bashrc + "\n" + cfg.bashrc;
  };
}
