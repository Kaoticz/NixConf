# Firefox settings (hardened)
# Based on: https://github.com/arkenfox/user.js
{
  ### STARTUP ###

  # Enables/Disables the "about:config" warning.
  "browser.aboutConfig.showWarning" = false;

  # Sets the startup page.
  # 0=blank, 1=home, 2=last visited page, 3=resume previous session
  "browser.startup.page" = 0;

  # Sets the page for new windows.
  # about:home=Firefox Home, custom URL, about:blank
  "browser.startup.homepage" = "about:blank";

  # Sets the page for new tabs
  # true=Firefox Home, false=blank page
  "browser.newtabpage.enabled" = false;

  # Sponsored content on Firefox Home
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

  # Clear default top sites
  "browser.newtabpage.activity-stream.default.sites" = "";

  ### GEOLOCATION / LANGUAGE / LOCALE ###

  # Use Mozilla's geolocation service instead of Google's, if permission is granted.
  "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

  # Disable using the OS's geolocation service.
  "geo.provider.use_geoclue" = false; # Linux
  # "geo.provider.use_corelocation" = false; # MacOS

  ### QUIETER FOX ###

  # Disable recommendation pane in "about:addons" (it uses Google Analytics).
  "extensions.getAddons.showPane" = false;

  # Disable recommendations in "about:addons" Extensions and Themes panes.
  "extensions.htmlaboutaddons.recommendations.enabled" = false;

  # Disable personalized Extension Recommendations in "about:addons" and AMO.
  "browser.discovery.enabled" = false;

  ### TELEMETRY ###

  # Disable new data submission.
  "datareporting.policy.dataSubmissionEnabled" = false;

  # Disable Health Reports.
  "datareporting.healthreport.uploadEnabled" = false;

  # Disable telemetry.
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled" = false;
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.updatePing.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;

  # Disable telemetry coverage.
  "toolkit.telemetry.coverage.opt-out" = true;
  "toolkit.coverage.opt-out" = true;
  "toolkit.coverage.endpoint.base" = "";

  # Disable PingCentre telemetry (used in several System Add-ons).
  "browser.ping-centre.telemetry" = false;

  # Disable Firefox Home telemetry.
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;

  # Disable Studies.
  "app.shield.optoutstudies.enabled" = false;

  # Disable Normandy/Shield, a telemetry system that can push and test "recipes".
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";

  # Disable crash reports.
  "browser.tabs.crashReporting.sendReport" = false;
  "breakpad.reportURL" = "";

  # Enforce no submission of backlogged Crash Reports.
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

  # Disable Captive Portal detection.
  # https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy ***/
  "network.captive-portal-service.enabled" = false;
  "captivedetect.canonicalURL" = "";

  # Disable Network Connectivity checks.
  "network.connectivity-service.enabled" = false;

  ### SAFE BROWSING (SB, a Google service) ###

  # Blocks dangerous and deceptive URLs.
  # Setting these to 'false' is dangerous - do it at your own risk.
  "browser.safebrowsing.malware.enabled" = true;
  "browser.safebrowsing.phishing.enabled" = true;

  # Allows SB to check downloads (lookups and remote).
  # Setting this to 'false' is dangerous - do it at your own risk.
  "browser.safebrowsing.downloads.enabled" = true;

  # Allows SB to check downloads (remote only).
  # Setting this to 'false' is dangerous - do it at your own risk.
  "browser.safebrowsing.downloads.remote.enabled" = false;
  "browser.safebrowsing.downloads.remote.url" = ""; # Comment this out if the setting above is true.

  # Allow SB to check downloads for "unwanted" and "uncommon" software.
  # Setting this to 'false' is dangerous - do it at your own risk.
  "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = true;
  "browser.safebrowsing.downloads.remote.block_uncommon" = true;

  # Enables/Disables the "Ignore this Warning" button on SB warnings.
  "browser.safebrowsing.allowOverride" = true;

  ### BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ###

  # Disable link prefetching.
  "network.prefetch-next" = false;

  # Disable DNS prefetching.
  "network.dns.disablePrefetch" = true;
  "network.dns.disablePrefetchFromHTTPS" = true;

  # Disable predictor / prefetching.
  "network.predictor.enabled" = false;
  "network.predictor.enable-prefetch" = false;

  # Disable link-mouseover opening connection to linked server.
  # https://news.slashdot.org/story/15/08/14/2321202/how-to-quash-firefoxs-silent-requests
  "network.http.speculative-parallel-limit" = 0;

  # Disable mousedown speculative connections on bookmarks and history.
  "browser.places.speculativeConnect.enabled" = false;

  # Enforce no "Hyperlink Auditing" (click tracking).
  "browser.send_pings" = false;

  ### DNS / DoH / PROXY / SOCKS / IPv6 ###

  # Disable IPv6
  "network.dns.disableIPv6" = true;

  # Set the proxy server to do any DNS lookups when using SOCKS.
  "network.proxy.socks_remote_dns" = true;

  # Disable using UNC (Uniform Naming Convention) paths.
  # Enabling this can break extensions for profiles on network shares.
  "network.file.disable_unc_paths" = true;

  # Disable GIO as a potential proxy bypass vector.
  "network.gio.supported-protocols" = "";

  # Enable/Disable proxy direct failover for system requests.
  # This is a security feature against malicious extensions.
  # Only set this to "false" if you use a proxy and trust your extensions.
  "network.proxy.failover_direct" = true;

  # Enable/Disable proxy bypass for system request failures.
  # Setting this to "false" will break the fallback for some security features.
  # Only set this to "false" if you use a proxy and understand the implications.
  "network.proxy.allow_bypass" = true;

  # Enable/Disable DNS-over-HTTPS (DoH).
  # Default uses Cloudflare's DNS. If you don't trust it, disable it by setting this value to 5
  # or provide another DNS of your choice with options 2 or 3.
  # 0=off by default, 2=TRR (Trusted Recursive Resolver) first, 3=TRR only, 5=explicitly off
  # See also: https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers
  "network.trr.mode" = 3;
  "network.ttr.uri" = "https://open.dns0.eu/"; # Required if mode is 2 or 3
  "network.ttr.custom_uri" = "https://open.dns0.eu/"; # Required if mode is 2 or 3

  ### LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ###

  # Enable/Disable location bar using search.
  # Only set this to "true" if you trust your default search engine.
  "keyword.enabled" = false;

  # Enable/Disable location bar domain guessing.
  # Domain guessing intercepts DNS "hostname not found errors" and resends a request (e.g. by adding www or .com).
  "browser.fixup.alternate.enabled" = false;

  # Enable/Disable live search suggestions.
  "browser.search.suggest.enabled" = false;
  "browser.urlbar.suggest.searches" = false;

  # Enable/Disable location bar making speculative connections.
  "browser.urlbar.speculativeConnect.enabled" = false;

  # Enable/Disable location bar leaking single words to a DNS provider **after searching**.
  # 0=never resolve, 1=use heuristics, 2=always resolve
  "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;

  # Enable/Disable location bar contextual suggestions.
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
  "browser.urlbar.suggest.quicksuggest.sponsored" = false;

  # Enable/Disable tab-to-search.
  "browser.urlbar.suggest.engines" = true;

  # Enable/Disable search and form history.
  # Set to "false" for better privacy.
  "browser.formfill.enable" = false;

  # Enable/Disable coloring of visited links.
  "layout.css.visited_links_enabled" = true;

  ### PASSWORDS ###

  # Enable/Disable auto-filling username & password form fields.
  "signon.autofillForms" = false;

  # Enable/Disable formless login capture for Password Manager.
  "signon.formlessCapture.enabled" = false;

  # Limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources
  # Hardens against potential credentials phishing.
  # 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
  # 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
  # 2 = allow sub-resources to open HTTP authentication credentials dialogs (default)
  "network.auth.subresource-http-auth-allow" = 1;

  # Enforce no automatic authentication on Microsoft sites.
  "network.http.windows-sso.enabled" = false;

  ###  DISK AVOIDANCE ###

  # Enable/Disable disk cache.
  "browser.cache.disk.enable" = false;

  # Force writing of media cache to memory in Private Browsing.
  "browser.privatebrowsing.forceMediaMemoryCache" = true;
  "media.memory_cache_max_size" = 65536;

  # Enable/Disable storing extra session data.
  # Defines on which sites to save extra session data such as form content, cookies and POST data.
  # 0=everywhere, 1=unencrypted sites, 2=nowhere
  "browser.sessionstore.privacy_level" = 2;

  # Enable/Disable favicons in shortcuts.
  "browser.shell.shortcutFavicons" = false;

  ### HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ###

  # Require safe negotiation. Blocks connections to servers that don't support RFC.
  "security.ssl.require_safe_negotiation" = true;

  # Enable/Disable TLS1.3 0-RTT (round-trip time).
  "security.tls.enable_0rtt_data" = false;

  # Enforce OCSP fetching to confirm current validity of certificates.
  # 0=disabled, 1=enabled (default), 2=enabled for EV certificates only.
  "security.OCSP.enabled" = 1;

  # Set OCSP fetch failures (non-stapled) to hard-fail.
  "security.OCSP.require" = true;

  # Enable/Disable strict PKP (Public Key Pinning).
  # 0=disabled, 1=allow user MiTM (default; such as an antivirus), 2=strict
  "security.cert_pinning.enforcement_level" = 2;

  # Enable/Disable CRLite.
  # 0 = disabled
  # 1 = consult CRLite but only collect telemetry
  # 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
  # 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (FF99+, default FF100+)
  "security.remote_settings.crlite_filters.enabled" = true;
  "security.pki.crlite_mode" = 2;

  # Enable/Disable insecure passive content (such as images) on https pages.
  "security.mixed_content.block_display_content" = false;

  # Enable/Disable HTTPS-Only mode in all windows.
  "dom.security.https_only_mode" = true; # Normal browsing
  "dom.security.https_only_mode_pbm" = true; # Private browsing

  # Enable/Disable HTTPS-Only mode for local resources.
  "dom.security.https_only_mode.upgrade_local" = false;

  # Enable/Disable HTTP background requests.
  # Disabling will cause sites that don't support HTTPS to timeout after 90 seconds.
  "dom.security.https_only_mode_send_http_background_request" = false;

  # Enable/Disable warning on the padlock for "broken security".
  "security.ssl.treat_unsafe_negotiation_as_broken" = true;

  # Display advanced information on Insecure Connection warning pages.
  "browser.xul.error_pages.expert_bad_cert" = true;

  # Sets font visibility.
  # 1=only base system fonts, 2=also fonts from optional language packs, 3=also user-installed fonts.
  "layout.css.font-visibility.private" = 3;
  "layout.css.font-visibility.standard" = 3;
  "layout.css.font-visibility.trackingprotection" = 3;

  # Controls when to send a cross-origin referer.
  # May cause breakage in older routers/modems and some sites (banks, vimeo, icloud, instagram).
  # If "2" is too strict, then override to "0" and use Smart Referer extension (Strict mode + add exceptions).
  # 0=always (default), 1=only if base domains match, 2=only if hosts match
  "network.http.referer.XOriginPolicy" = 2;

  # Control the amount of cross-origin information to send.
  # 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port.
  "network.http.referer.XOriginTrimmingPolicy" = 2;

  ### CONTAINERS ###

  # Enable/Disable Container Tabs and its UI setting.
  "privacy.userContext.enabled" = true;
  "privacy.userContext.ui.enabled" = true;

  # Set behavior on "+ Tab" button to display container menu on left click.
  # The menu is always shown on long press and right click.
  "privacy.userContext.newTabContainerOnLeftClick.enabled" = false;

  ### PLUGINS / MEDIA / WEBRTC ###

  # Force WebRTC inside the proxy.
  "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

  # Force a single network interface for ICE candidates generation.
  # When using a system-wide proxy, it uses the proxy interface.
  "media.peerconnection.ice.default_address_only" = true;

  # Force exclusion of private IPs from ICE candidates.
  # Seting this to "true" may break video-conferencing platforms.
  "media.peerconnection.ice.no_host" = true;

  # Enable/Disable GMP (Gecko Media Plugins).
  "media.gmp-provider.enabled" = true;

  # Enable/Disable widevine CDM (Content Decryption Module).
  "media.gmp-widevinecdm.enabled" = true;

  # Enable/Disable all DRM content (EME: Encryption Media Extension)
  # This breaks platforms that rely on DRM, such as Netflix, Amazon Prime, Hulu, HBO, etc...
  "media.eme.enabled" = false;
  "browser.eme.ui.enabled" = true; # Shows/Hides the setting which also disables the DRM prompt.

  ### DOM (DOCUMENT OBJECT MODEL) ###

  # Prevent scripts from moving and resizing open windows.
  "dom.disable_window_move_resize" = true;

  ### MISCELLANEOUS ###

  # Prevents accessibility services from accessing your browser.
  "accessibility.force_disabled" = 1;

  # Remove temporary files opened with an external application.
  "browser.helperApps.deleteTempFileOnExit" = true;

  # Disable UITour backend so there is no chance that a remote page can use it.
  "browser.uitour.enabled" = false;
  "browser.uitour.url" = "";

  # Set remote debugging to disabled.
  "devtools.debugger.remote-enabled" = false;

  # Disable middle mouse click opening links from clipboard.
  "middlemouse.contentLoadURL" = false;

  # Disable websites overriding Firefox's keyboard shortcuts.
  # 0 (default) or 1=allow, 2=block
  "permissions.default.shortcuts" = 2;

  # Remove special permissions for certain mozilla domains.
  "permissions.manager.defaultsUrl" = "";

  # Remove webchannel whitelist.
  "webchannel.allowObject.urlWhitelist" = "";

  # Use Punycode in Internationalized Domain Names to eliminate possible spoofing.
  # Setting this to "true" might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded.
  # Test: https://www.xn--80ak6aa92e.com/ (www.apple.com)
  "network.IDN_show_punycode" = true;

  # Enforce PDFJS, and disable PDFJS scripting.
  "pdfjs.disabled" = false;
  "pdfjs.enableScripting" = false;

  # Disable permissions delegation.
  "permissions.delegation.enabled" = false;

  # Enable/Disable user interaction for security by always asking where to download.
  "browser.download.useDownloadDir" = false;

  # Enable/Disable downloads panel opening on every download.
  "browser.download.alwaysOpenPanel" = false;

  # Disable adding downloads to the system's "recent documents" list.
  "browser.download.manager.addToRecentDocs" = false;

  # Enable user interaction for security by always asking how to handle new mimetypes.
  "browser.download.always_ask_before_handling_new_types" = true;

  # Lock down allowed extension directories.
  # This will break extensions, language packs, themes and any other XPI files which are installed outside of profile and application directories.
  "extensions.enabledScopes" = 5;
  "extensions.autoDisableScopes" = 15;

  # Disable bypassing 3rd party extension install prompts.
  "extensions.postDownloadThirdPartyPrompt" = false;

  # Disable webextension restrictions on certain mozilla domains.
  "extensions.webextensions.restrictedDomains" = "";

  ### ETP (ENHANCED TRACKING PROTECTION) ###

  # Enable ETP Strict Mode - ETP Strict Mode enables Total Cookie Protection (TCP).
  "browser.contentblocking.category" = "strict";

  # Enable/Disable ETP web compatibility features.
  # Set this to "false" to get more privacy.
  "privacy.antitracking.enableWebcompat" = true;

  # Enable state partitioning of service workers.
  "privacy.partition.serviceWorkers" = true;

  # Enable APS (Always Partitioning Storage).
  "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
  "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;

  ### SHUTDOWN & SANITIZING ###

  # Forces Firefox to delete browsing items on shutdown.
  "privacy.sanitize.sanitizeOnShutdown" = true;

  # Set all of these to "true" to get more privacy.
  "privacy.clearsitedata.cache.enabled" = true;
  "privacy.clearOnShutdown.cache" = true;
  "privacy.clearOnShutdown.downloads" = true;
  "privacy.clearOnShutdown.formdata" = true;
  "privacy.clearOnShutdown.history" = true;
  "privacy.clearOnShutdown.sessions" = true;
  "privacy.clearOnShutdown.siteSettings" = false;
  "privacy.clearOnShutdown.openWindows" = false; # If true, this prevents resuming from crashes
  "privacy.clearOnShutdown.cookies" = true;
  "privacy.clearOnShutdown.offlineApps" = true; # Site data.

  ### SANITIZE MANUAL: IGNORES "ALLOW" SITE EXCEPTIONS ###

  # Reset default items to clear with Ctrl-Shift-Del.
  "privacy.cpd.cache" = true;
  "privacy.cpd.formdata" = true;
  "privacy.cpd.history" = true;
  "privacy.cpd.sessions" = true;
  "privacy.cpd.offlineApps" = false;
  "privacy.cpd.cookies" = false;

  # Reset default "Time range to clear" for "Clear Recent History".
  "privacy.sanitize.timeSpan" = 0;

  ### RFP (RESIST FINGERPRINTING) ###

  # Enable RFP.
  # This may cause the canvas of some websites to break, but you can add exceptions if necessary.
  "privacy.resistFingerprinting" = true;

  # Set new window size rounding max values.
  # Sizes round down in hundreds: width to 200s and height to 100s, to fit your screen.
  "privacy.window.maxInnerWidth" = 1600;
  "privacy.window.maxInnerHeight" = 900;

  # Disable mozAddonManager Web API.
  "privacy.resistFingerprinting.block_mozAddonManager" = true;

  # Enable RFP letterboxing.
  # Dynamically resizes the inner window by applying margins in stepped ranges.
  # This is independent of RFP (4501). If you're not using RFP, or you are but dislike the margins, then flip this preference, keeping in mind that it is effectively fingerprintable.
  # Set this to "true" to get more privacy. If it's too annoying, then set to "false" and install the extension CanvasBlocker.
  "privacy.resistFingerprinting.letterboxing" = true;

  # Disable using system colors.
  "browser.display.use_system_colors" = false;

  # Enforce non-native widget theme.
  "widget.non-native-theme.enabled" = true;

  # Enforce links targeting new windows to open in a new tab instead.
  # You can still right-click and open a new window.
  # 1=most recent window or tab, 2=new window, 3=new tab
  "browser.link.open_newwindow" = 3;

  # Set all open window methods to abide by "browser.link.open_newwindow".
  "browser.link.open_newwindow.restriction" = 0;

  # Disable WebGL (Web Graphics Library).
  "webgl.disabled" = true;

  ### OPTIONAL OPSEC (Disk avoidance, application data isolation, eyeballs...) ###

  # Visit the following URL for more details, as none of the options are enabled by default.
  # https://github.com/arkenfox/user.js/blob/master/user.js

  ### OPTIONAL HARDENING (changing these may cause breakage) ###

  # Visit the following URL for more details, as none of the options are enabled by default.
  # https://github.com/arkenfox/user.js/blob/master/user.js

  ### DON'T TOUCH ###

  # Enforce Firefox's blocklist.
  "extensions.blocklist.enabled" = true;

  # Enforce no referer spoofing.
  "network.http.referer.spoofSource" = false;

  # Enforce a security delay on some confirmation dialogs such as install, open/save.
  "security.dialog_enable_delay" = 1000;

  # Enforce no First Party Isolation.
  # Replaced with network partitioning (FF85+) and TCP (2701), and enabling FPI.
  "privacy.firstparty.isolate" = false;

  # Enforce SmartBlock shims.
  "extensions.webcompat.enable_shims" = true;

  # Enforce no TLS 1.0/1.1 downgrades.
  "security.tls.version.enable-deprecated" = false;

  # Enforce disabling of Web Compatibility Reporter.
  "extensions.webcompat-reporter.enabled" = false;

  ### OTHERS ###

  # Disable welcome notices.
  "browser.startup.homepage_override.mstone" = "ignore";

  # Disable General>Browsing>Recommend extensions/features as you browse.
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

  # Disable What's New toolbar icon.
  "browser.messaging-system.whatsNewPanel.enabled" = false;

  # Disable search terms.
  # Search>Search Bar>Use the address bar for search and navigation>Show search terms instead of URL...
  "browser.urlbar.showSearchTerms.enabled" = false;
}
