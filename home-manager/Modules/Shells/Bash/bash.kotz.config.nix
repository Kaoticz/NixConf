{ lib, config, pkgs, ... }:
let
  cfg = config.kotz.bash;
  bleshBashrcFactory = import ./Settings/bash.blesh.settings.nix;
  supportedEnvs = {
    none = { aliases = { }; bashrc = ""; };
    pantheon = import ./Settings/bash.pantheon.settings.nix { inherit pkgs; };
  };
  baseAliases = {
    homenix = "nano ~/.config/home-manager/home.nix";
    cleanupgennix = "home-manager remove-generations";
    cleanupnix = "nix-collect-garbage && echo -e '\nUse listgennix to list generations and cleanupgennix <ids> to delete one or multiple generations.\n'";
    listnix = "home-manager packages";
    listgennix = "home-manager generations";
    ls = "exa -al --color=always --group-directories-first";
    nixconf = "sudo nano /etc/nixos/configuration.nix";
    update = "sudo nix-channel --update && sudo nixos-rebuild switch";
    update-home = "nix-channel --update && home-manager switch";
    update-all = "update && update-home";
    rollback-list = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    rollback-clear = "sudo nix-collect-garbage -d";
    inithost = "sudo mkdir -p /mnt/host && sudo mount -t virtiofs host-fs /mnt/host";
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
      description = "The environments supported by this module.";
    };
    bashrc = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra code to be called after environment's bashrc code.";
    };
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Install packages
    home.packages = with pkgs;
      if cfg.enableBlesh
      then [ exa blesh ]
      else
        if cfg.enableAliases
        then [ exa ]
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
