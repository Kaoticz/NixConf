{ pkgs, config, ... }:
let
  firefox_hardened_settings = import ./Settings/firefox-hardened.settings.nix;
  nur = import ../Dependencies/nur.config.nix { inherit pkgs; };
  nix_packages_search_engine = {
    urls = [{
      template = "https://search.nixos.org/packages";
      params = [
        { name = "type"; value = "packages"; }
        { name = "query"; value = "{searchTerms}"; }
      ];
    }];

    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@np" ];
  };
  nix_wiki_search_engine = {
    urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
    iconUpdateURL = "https://nixos.wiki/favicon.png";
    updateInterval = 24 * 60 * 60 * 1000; # every day
    definedAliases = [ "@nw" ];
  };
in
{
  # Config for Firefox's default profile.
  programs.firefox.enable = true;
  programs.firefox.profiles.insecure = {
    id = 0;
    isDefault = false;
    search.default = "DuckDuckGo";
    search.engines = {
      "Nix Packages" = nix_packages_search_engine;
      "NixOS Wiki" = nix_wiki_search_engine;

      "DuckDuckGo".metaData.alias = "@ddg";
      "Amazon.com".metaData.hidden = true;
    };
    extensions = with nur.repos.rycee.firefox-addons; [
      user-agent-string-switcher
      ublock-origin
      darkreader
      umatrix
    ];
    settings = {
      "browser.startup.page" = 3;
    };
  };

  programs.firefox.profiles.${config.home.username} = {
    # Set the home profile as the default profile
    id = 1;
    isDefault = true;

    # Browser search engines
    search.default = "DuckDuckGo";
    search.order = [
      "DuckDuckGo"
      "Wikipedia (en)"
      "Nix Packages"
      "NixOS Wiki"
    ];

    search.engines = {
      "Nix Packages" = nix_packages_search_engine;
      "NixOS Wiki" = nix_wiki_search_engine;

      "DuckDuckGo".metaData.alias = "@ddg";
      "Bing".metaData.hidden = true;
      "Google".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
    };

    # Browser addons
    extensions = with nur.repos.rycee.firefox-addons; [
      augmented-steam
      auto-tab-discard
      behave
      canvasblocker # Install this if you're not using RFP or letterboxing.
      darkreader
      flagfox
      gloc
      libredirect
      multi-account-containers
      refined-github
      return-youtube-dislikes
      sourcegraph
      temporary-containers
      terms-of-service-didnt-read
      ublock-origin
      umatrix
      unpaywall
      user-agent-string-switcher
      youtube-nonstop
      youtube-shorts-block

      ## Missing
      # Authenticator
      # Fireshot
      # Github Download Button
      # Imagus
    ];

    # Browser settings (with overrides)
    settings = firefox_hardened_settings // {
      "browser.startup.page" = 3;
      "browser.startup.homepage" = "about:home";
      "browser.newtabpage.enabled" = true;
      "keyword.enabled" = true;
      "browser.formfill.enable" = true;
      "browser.cache.disk.enable" = true;
      "browser.shell.shortcutFavicons" = true;
      "browser.download.useDownloadDir" = true;
      "browser.download.alwaysOpenPanel" = true;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.sessions" = false;

      # Install the CanvasBlocker extension to mitigate the lack of letterboxing.
      "privacy.window.maxInnerWidth" = null;
      "privacy.window.maxInnerHeight" = null;
      "privacy.resistFingerprinting.letterboxing" = false;
    };
  };
}
