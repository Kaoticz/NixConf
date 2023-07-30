{ ... }:

{
  # Import all modules.
  imports = [
    # Themes
    ./Themes/gtk.kotz.config.nix

    # Development
    ./Development/git.kotz.config.nix
    ./Development/vscode.kotz.config.nix

    # Web
    ./Web/firefox.kotz.config.nix

    # Shells
    ./Shells/Bash/bash.kotz.config.nix
  ];
}
