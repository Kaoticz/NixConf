{ pkgs, config, ... }:
let
  nur = (import (../Dependencies/nur.config.nix) { inherit pkgs; }).nur;
in
{
  # Config for Firefox's default profile.
  programs.firefox.enable = true;
  programs.firefox.profiles.${config.home.username} = {
    # Set the home profile as the default profile
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
      "Nix Packages" = {
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

      "NixOS Wiki" = {
        urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
        iconUpdateURL = "https://nixos.wiki/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@nw" ];
      };

      "DuckDuckGo".metaData.alias = "@ddg";
      "Bing".metaData.hidden = true;
      "Google".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
    };

    # Browser addons
    extensions = with nur.repos.rycee.firefox-addons; [
      augmented-steam
      canvasblocker
      clearurls
      darkreader
      decentraleyes
      flagfox
      gloc
      multi-account-containers
      return-youtube-dislikes
      temporary-containers
      ublock-origin
      umatrix
      unpaywall
      user-agent-string-switcher
      youtube-nonstop

      # Novelties
      auto-tab-discard
      libredirect # Replaces "privacy-redirect"
      #localcdn        # Replaces "decentraleyes"?
      refined-github
      sourcegraph
      terms-of-service-didnt-read
      youtube-shorts-block

      ## Missing
      # Fireshot
      # Github Download Button
      # HTTPS Everywhere
      # Imagus
    ];

    # Browser settings
    settings = {
      "browser.startup.page" = 3; # Restores tabs from the last session (set to 1 to disable)
    };
  };
}
