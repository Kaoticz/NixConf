{ ... }:

{
  # Import all modules.
  imports = [
    ./Shells/Bash/bash.kotz.config.nix
    ./Web/firefox.kotz.config.nix
    ./Development/git.kotz.config.nix
    ./Development/vscode.kotz.config.nix
  ];
}
