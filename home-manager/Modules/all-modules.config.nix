{ ... }:

{
  # Import all modules.
  imports = [
    # Development
    ./Development/git.kotz.config.nix
    ./Development/vscode.kotz.config.nix

    # Web
    ./Web/firefox.kotz.config.nix

    # Shells
    ./Shells/Bash/bash.kotz.config.nix
  ];
}
