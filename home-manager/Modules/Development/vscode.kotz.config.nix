{ lib, pkgs, config, ... }:
let
  cfg = config.kotz.vscode;
  extensions = import ../Dependencies/vscode.extensions.nix;
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
      dotnet-sdk_8 # .NET 8
      nil # Nix LSP server
      nixpkgs-fmt # Nix code formatter
      python3 # CPython
      shellcheck # Bash analyzer
    ];

    # Install VSCode.
    programs.vscode.enable = true;
    programs.vscode.enableUpdateCheck = false;

    # Install extensions.
    programs.vscode.extensions = with extensions.vscode-marketplace; [
      # Bash
      mads-hartmann.bash-ide-vscode
      timonwong.shellcheck

      # C / C++
      ms-vscode.cpptools-extension-pack
      ms-vscode.makefile-tools

      # C#
      (ms-dotnettools.csdevkit.overrideAttrs (_: { sourceRoot = "./extension"; }))
      (ms-dotnettools.vscodeintellicode-csharp.overrideAttrs (_: { sourceRoot = "./extension"; }))
      adrianwilczynski.namespace
      fernandoescolar.vscode-solution-explorer
      fireside21.cshtml
      k--kato.docomment
      ms-dotnettools.csharp
      ms-dotnettools.vscode-dotnet-runtime
      patcx.vscode-nuget-gallery

      # Python
      ms-python.python
      ms-python.vscode-pylance

      # Nix
      jnoortheen.nix-ide

      # Web
      dbaeumer.vscode-eslint
      ecmel.vscode-html-css
      firefox-devtools.vscode-firefox-debug
      html-validate.vscode-html-validate
      ms-azuretools.vscode-docker

      # Markdown
      shd101wyy.markdown-preview-enhanced

      # Tools
      rangav.vscode-thunder-client
    ];

    # Keybindings.
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

    # User settings.
    programs.vscode.userSettings = {
      # Editor
      "telemetry.telemetryLevel" = "off";
      "workbench.colorTheme" = "Visual Studio 2019 Dark";
      "workbench.preferredDarkColorTheme" = "Visual Studio 2019 Dark";
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

      # Git
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "git.enableCommitSigning" = true;

      # C and C++
      "cmake.configureOnOpen" = true;
      "cmake.showOptionsMovedNotification" = false;
      "C_Cpp.errorSquiggles" = "enabled";
      "C_Cpp.default.cStandard" = "gnu11";
      "C_Cpp.vcFormat.space.pointerReferenceAlignment" = "right";

      # C#
      "csharp.maxProjectFileCountForDiagnosticAnalysis" = 100;
      "csharp.semanticHighlighting.enabled" = true;
      "csharp.suppressHiddenDiagnostics" = false;
      "dotnetAcquisitionExtension.enableTelemetry" = false;
      "omnisharp.enableEditorConfigSupport" = true;
      "omnisharp.useModernNet" = true;
      #"dotnet.dotnetPath" = "/home/${config.home.username}/.nix-profile/bin/dotnet";
      #"omnisharp.sdkPath" = "/home/${config.home.username}/.nix-profile/bin/dotnet";
      #"dotnet.preferCSharpExtension" = false;
      # "dotnetAcquisitionExtension.existingDotnetPath" = [
      #   {
      #     "extensionId" = "ms-dotnettools.csdevkit";
      #     "path" = "/home/${config.home.username}/.nix-profile/bin/dotnet";
      #   }
      # ];
      "NugetGallery.sources" = [
        "{\"name\": \"nuget.org\",\"url\": \"https://api.nuget.org/v3/index.json\"}"
      ];

      # Javascript
      "json.schemas" = [ ];
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "debug.javascript.autoAttachFilter" = "smart";

      # Markdown
      "markdown-preview-enhanced.previewTheme" = "github-dark.css";

      # Python
      "python.experiments.enabled" = false;
      "python.analysis.inlayHints.variableTypes" = true;
      "python.analysis.inlayHints.pytestParameters" = true;
      "python.analysis.inlayHints.functionReturnTypes" = true;

      # Bash
      "shellcheck.customArgs" = [ "-x" ];
      "shellcheck.exclude" = [
        "2001"
      ];

      # Nix
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverPath" = "nil";
      "nix.enableLanguageServer" = true;
    };
  };
}
