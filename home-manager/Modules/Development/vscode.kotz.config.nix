{ lib, pkgs, config, ... }:
let
  cfg = config.kotz.vscode;
in
{
  # Imports: extra modules this module uses.
  imports = [ ];

  # Options: settings the user can change.
  options.kotz.vscode = {
    enable = lib.mkEnableOption "Kotz's VSCode configuration.";
  };

  # Config: things that must be done if this module is enabled.
  config = lib.mkIf cfg.enable {
    # Install packages
    home.packages = with pkgs; [
      dotnet-sdk_7 # .NET 7
      nil # Nix LSP server
      nixpkgs-fmt # Nix code formatter
      shellcheck # Bash analyzer
    ];

    #Install VSCode
    programs.vscode.enable = true;
    programs.vscode.enableUpdateCheck = false;
    programs.vscode.extensions = with pkgs; [
      vscode-extensions.shd101wyy.markdown-preview-enhanced
      vscode-extensions.mads-hartmann.bash-ide-vscode
      vscode-extensions.formulahendry.auto-close-tag
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.timonwong.shellcheck
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.eamodio.gitlens
    ];

    programs.vscode.keybindings = [
      {
        "key" = "ctrl+k ctrl+o";
        "command" = "editor.action.addCommentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+k ctrl+c";
        "command" = "-editor.action.addCommentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+k ctrl+u";
        "command" = "editor.action.removeCommentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+k ctrl+u";
        "command" = "-editor.action.removeCommentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+r ctrl+r";
        "command" = "editor.action.rename";
        "when" = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
      }
    ];

    programs.vscode.userSettings = {
      # Editor
      "telemetry.telemetryLevel" = "off";
      "workbench.colorTheme" = "Default Dark+";
      "workbench.editor.wrapTabs" = true;
      "explorer.excludeGitIgnore" = true;
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 5000;
      "diffEditor.codeLens" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.fontFamily" = "'Consolas', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.bracketPairColorization.enabled" = false;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.fontSize" = 14;
      "editor.quickSuggestions" = {
        "comments" = "on";
        "strings" = "on";
        "other" = "on";
      };
      "files.exclude" = {
        "**/node_modules" = true;
      };

      # C#
      "csharp.maxProjectFileCountForDiagnosticAnalysis" = 100;
      "csharp.semanticHighlighting.enabled" = true;
      "csharp.suppressHiddenDiagnostics" = false;
      "omnisharp.enableEditorConfigSupport" = true;
      "omnisharp.enableRoslynAnalyzers" = true;
      "omnisharp.useModernNet" = true;
      "NugetGallery.sources" = [
        "{\"name\": \"nuget.org\",\"url\": \"https://api.nuget.org/v3/index.json\"}"
      ];

      # Git
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "git.enableCommitSigning" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.statusBar.enabled" = false;
      "gitlens.hovers.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";

      # Javascript
      "json.schemas" = [ ];
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "debug.javascript.autoAttachFilter" = "smart";

      # Markdown
      "markdown-preview-enhanced.previewTheme" = "github-dark.css";

      # Bash
      "shellcheck.customArgs" = [ "-x" ];
      "shellcheck.exclude" = [
        "2155"
        "2001"
      ];

      # Nix
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverPath" = "nil";
      "nix.enableLanguageServer" = true;
    };
  };
}
