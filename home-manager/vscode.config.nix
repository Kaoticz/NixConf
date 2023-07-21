{ pkgs, ... }:

{
  programs.vscode.enable = true;
  programs.vscode.enableUpdateCheck = false;
  programs.vscode.extensions = with pkgs; [
    # vscode-extensions.ms-dotnettools.csharp
    vscode-extensions.timonwong.shellcheck
    vscode-extensions.formulahendry.auto-close-tag
    vscode-extensions.shd101wyy.markdown-preview-enhanced
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
    "telemetry.telemetryLevel" = "off";
    "csharp.maxProjectFileCountForDiagnosticAnalysis" = 100;
    "csharp.semanticHighlighting.enabled" = true;
    "csharp.suppressHiddenDiagnostics" = false;
    "omnisharp.enableEditorConfigSupport" = true;
    "omnisharp.enableRoslynAnalyzers" = true;
    "omnisharp.useModernNet" = true;
    "NugetGallery.sources" = [
        "{\"name\": \"nuget.org\",\"url\": \"https://api.nuget.org/v3/index.json\"}"
    ];
    "editor.formatOnPaste" = true;
    "diffEditor.codeLens" = true;
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 5000;
    "editor.quickSuggestions" = {
        "comments" = "on";
        "strings" = "on";
        "other" = "on";
    };
    "files.exclude" = {
        "**/node_modules" = true;
    };
    "editor.fontFamily" = "'Consolas', 'monospace', monospace, 'Droid Sans Fallback'";
    "editor.formatOnType" = true;
    "git.enableSmartCommit" = true;
    "editor.fontSize" = 14;
    "git.autofetch" = true;
    "git.enableCommitSigning" = true;
    "diffEditor.ignoreTrimWhitespace" = false;
    "javascript.updateImportsOnFileMove.enabled" = "always";
    "gitlens.codeLens.enabled" = false;
    "gitlens.statusBar.enabled" = false;
    "gitlens.hovers.enabled" = false;
    "gitlens.currentLine.enabled" = false;
    "gitlens.hovers.currentLine.over" = "line";
    "debug.javascript.autoAttachFilter" = "smart";
    "json.schemas" = [];
    "workbench.colorTheme" = "Default Dark+";
    "editor.bracketPairColorization.enabled" = false;
    "explorer.excludeGitIgnore" = true;
    "markdown-preview-enhanced.previewTheme" = "github-dark.css";
    "shellcheck.exclude" = [
          "2155"
          "2001"
      ];
  };
}
