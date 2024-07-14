{lib, ...}: {
  imports = [
    ./search-engines
    ./settings
  ];

  ne.firefox = {
    searchEngines = {
      default = "DuckDuckGo";

      noUseless = true;
      defaultAliases = true;
      custom = {
        nixPackages = true;
        nixOptions = true;
        nixWiki = true;
        youTube = true;
      };
    };

    settings = {
      noUseless = true;
      security = true;
      interface = true;
      custom = {
        minimalSuggestions = true;
        restoreSession = true;
      };
    };
  };

  programs = {
    firefox = {
      enable = true;

      # https://mozilla.github.io/policy-templates/
      # about:policies#documentation

      policies = {
        # Extensions
        ExtensionSettings = let
          install_custom = uuid: url: {
            name = uuid;
            value = {
              install_url = url;
              installation_mode = "force_installed";
            };
          };
          install_store = uuid: shortId: (
            install_custom
            uuid
            "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi"
          );
        in
          {
            # "*" = {
            #   installation_mode = "blocked";
            #   blocked_install_message = "Install through Nix";
            # };
          }
          // lib.listToAttrs [
            (install_store "uBlock0@raymondhill.net" "ublock-origin")
            (install_store "addon@darkreader.org" "darkreader")
          ];

        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net".adminSettings = let
            imported = [
              "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            ];
          in {
            userSettings = {
              externalLists = lib.concatStringsSep "\n" imported;
            };
            selectedFilterLists =
              [
                # Built-in
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                # Ads
                "easylist"
                "adguard-generic"
                # Privacy
                "easyprivacy"
                "adguard-spyware"
                "adguard-spyware-url"
                # Malware protection, security
                "urlhaus-1"
                # Multipurpose
                "plowe-0"
                # Cookie notices
                "fanboy-cookiemonster"
                "ublock-cookies-easylist"
                "adguard-cookies"
                # Social widgets
                "fanboy-social"
                "adguard-social"
                # Annoyances
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easylist-annoyances"
                "adguard-mobile-app-banners"
                "adguard-other-annoyances"
                "adguard-popup-overlays"
                "adguard-widgets"
                "ublock-annoyances"
                # Regions, languages
                "FRA-0"
                "RUS-0"
              ]
              ++ imported;
          };
          "addon@darkreader.org" = {
            detectDarkTheme = true;
            fetchNews = false;
          };
        };

        # addons-search-detection@mozilla.com
        # bing@search.mozilla.org
        # addon@darkreader.org
        # ddg@search.mozilla.org
        # ebay@search.mozilla.org
        # google@search.mozilla.org
        # {cb31ec5d-c49a-4e5a-b240-16c767444f62}
        # {9076cefe-e6f8-4883-a480-9f968bd09249}
        # {762f9885-5a13-4abd-9c77-433dcd38b8fd}
        # {2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}
        # simple-tab-groups@drive4ik
        # sponsorBlocker@ajay.app
        # uBlock0@raymondhill.net
        # {ffadac89-63bb-4b04-be90-8cb2aa323171}
        # wikipedia@search.mozilla.org
        # default-theme@mozilla.org
        # firefox-compact-dark@mozilla.org
        # firefox-alpenglow@mozilla.org
        # firefox-compact-light@mozilla.org
      };

      profiles.default = {
        isDefault = true;
      };
    };
  };

  # json = home.file.".mozilla/firefox/default/extension-preferences.json".text;
}
