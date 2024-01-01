(import
  (builtins.fetchGit "https://github.com/nix-community/nix-vscode-extensions")
).extensions.${builtins.currentSystem}
