{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    extensions = with pkgs; [
      # vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.timonwong.shellcheck
      vscode-extensions.formulahendry.auto-close-tag
      vscode-extensions.shd101wyy.markdown-preview-enhanced
      vscode-extensions.b4dm4n.vscode-nixpkgs-fmt
    ];
    keybindings = [
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

    userSettings = {
      "telemetry.telemetryLevel" = "off";
      "workbench.colorTheme" = "Default Dark+";
      "csharp.maxProjectFileCountForDiagnosticAnalysis" = 100;
      "csharp.semanticHighlighting.enabled" = true;
      "csharp.suppressHiddenDiagnostics" = false;
      "omnisharp.enableEditorConfigSupport" = true;
      "omnisharp.enableRoslynAnalyzers" = true;
      "omnisharp.useModernNet" = true;
      "NugetGallery.sources" = [
        "{\"name\": \"nuget.org\",\"url\": \"https://api.nuget.org/v3/index.json\"}"
      ];
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
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "git.enableCommitSigning" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.statusBar.enabled" = false;
      "gitlens.hovers.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "json.schemas" = [ ];
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "debug.javascript.autoAttachFilter" = "smart";
      "markdown-preview-enhanced.previewTheme" = "github-dark.css";
      "shellcheck.exclude" = [
        "2155"
        "2001"
      ];
    };
  };
}
