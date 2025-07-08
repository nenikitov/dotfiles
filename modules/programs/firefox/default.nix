{
  lib,
  mkModule,
  pkgs,
  ...
}:
mkModule {
  path = ["programs" "firefox"];
  description = "Firefox web-browser";
  options = {
    search = {
      default = lib.mkOption {
        description = "Deafult search engine to use for regular windows.";
        default = "Brave Search";
        example = "DuckDuckGo (custom)";
        type = lib.types.str;
      };
      linux = {
        enable = lib.mkEnableOption "addition of linux-related search engines" // {default = true;};
        nixVersion = lib.mkOption {
          description = "Channel or version that NixOS follows";
          default = "unstable";
          example = "25.05";
          type = lib.types.str;
        };
        homeManagerVersion = lib.mkOption {
          description = "Channel or version that Home Manager follows";
          default = "unstable";
          example = "25.05";
          type = lib.types.str;
        };
      };
      games = {
        enable = lib.mkEnableOption "addition of game-related search engines" // {default = true;};
      };
    };
  };
  config = {configModule, ...}: {
    programs.firefox.enable = true;
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        extraPrefs =
        # TODO: Make this look better
        # js
        ''
          pref("privacy.resistFingerprinting", false);
          defaultPref("findbar.highlightAll", true);
          pref("webgl.disabled", false);
          pref("middlemouse.paste", false);
          pref("general.autoScroll", true);
          pref("browser.tabs.closeWindowWithLastTab", false);
          pref("browser.search.suggest.enabled.private", true);
          pref("browser.urlbar.suggest.topsites", false);
          pref("svg.context-properties.content.enabled", true);
          pref("browser.uidensity", 1);
        '';
        extraPolicies = {
          DisplayMenuBar = "default-off";
          DisplayBookmarksToolbar = "never";
          SanitizeOnShutdown = false;
          Homepage.StartPage = "previous-session";
          Permissions.Notifications.BlockNewRequests = true;
          SearchSuggestEnabled = true;
          SearchEngines = {
            Default = configModule.search.default;
            Remove = [
              "Amazon.com"
              "Bing"
              "DuckDuckGo"
              "eBay"
              "Google"
              "Twitter"
              "Wikipedia (en)"
            ];
            Add =
              [
                {
                  Name = "Brave Search";
                  Alias = "b";
                  IconURL = "https://upload.wikimedia.org/wikipedia/commons/d/da/Brave_search_logo.png";
                  Method = "GET";
                  URLTemplate = "https://search.brave.com/search?q={searchTerms}";
                  SuggestURLTemplate = "https://search.brave.com/api/suggest?q={searchTerms}";
                }
                {
                  Name = "DuckDuckGo (custom)";
                  Alias = "d";
                  IconURL = "https://duckduckgo.com/assets/icons/meta/DDG-icon_256x256.png";
                  Method = "GET";
                  URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
                  SuggestURLTemplate = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
                }
                {
                  Name = "Startpage";
                  Alias = "s";
                  IconURL = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
                  Method = "GET";
                  URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
                  SuggestURLTemplate = "https://www.startpage.com/osuggestions?q={searchTerms}";
                }
                {
                  Name = "Google (custom)";
                  Alias = "g";
                  IconURL = "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico";
                  Method = "GET";
                  URLTemplate = "https://www.google.com/search?q={searchTerms}";
                  SuggestURLTemplate = "https://www.google.com/complete/search?q={searchTerms}&client=chrome";
                }
                {
                  Name = "YouTube";
                  Alias = "y";
                  IconURL = "https://www.youtube.com/s/desktop/2253fa3d/img/logos/favicon_144x144.png";
                  Method = "GET";
                  URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
                }
                {
                  Name = "GitHub";
                  Alias = "gh";
                  IconURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
                  Method = "GET";
                  URLTemplate = "https://github.com/search?q={searchTerms}";
                }
                {
                  Name = "Reddit";
                  Alias = "r";
                  IconURL = "https://www.redditstatic.com/shreddit/assets/favicon/192x192.png";
                  Method = "GET";
                  URLTemplate = "https://www.reddit.com/search/?q={searchTerms}";
                }
              ]
              ++ (
                if configModule.search.linux.enable
                then [
                  {
                    Name = "Arch wiki";
                    Alias = "law";
                    IconURL = "https://wiki.archlinux.org/favicon.ico";
                    Method = "GET";
                    URLTemplate = "https://wiki.archlinux.org/index.php?search={searchTerms}";
                    SuggestURLTemplate = "https://wiki.archlinux.org/api.php?action=opensearch&search={searchTerms}";
                  }
                  {
                    Name = "NixOS wiki";
                    Alias = "lnw";
                    IconURL = "https://nixos.wiki/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
                    SuggestURLTemplate = "https://nixos.wiki/api.php?action=opensearch&search={searchTerms}";
                  }
                  {
                    Name = "Nix library and builtins";
                    Alias = "lnl";
                    IconURL = "https://noogle.dev/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                  }
                  {
                    Name = "NixOS options";
                    Alias = "lno";
                    IconURL = "https://search.nixos.org/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://search.nixos.org/options?query={searchTerms}&channel=${configModule.search.linux.nixVersion}";
                  }
                  {
                    Name = "NixOS packages";
                    Alias = "lnp";
                    IconURL = "https://search.nixos.org/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}&channel=${configModule.search.linux.nixVersion}";
                  }
                  {
                    Name = "Home Manager options";
                    Alias = "lho";
                    IconURL = "https://search.nixos.org/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}&release=${if configModule.search.linux.homeManagerVersion == "unstable" then "master" else configModule.search.linux.homeManagerVersion}";
                  }
                  {
                    Name = "Home Manager packages";
                    Alias = "lhp";
                    IconURL = "https://search.nixos.org/favicon.png";
                    Method = "GET";
                    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}&channel=${configModule.search.linux.homeManagerVersion}";
                  }
                ]
                else []
              )
              ++ (
                if configModule.search.games.enable
                then [
                  {
                    Name = "Terraria wiki";
                    Alias = "gt";
                    IconURL = "https://terraria.wiki.gg/images/4/4a/Site-favicon.ico";
                    URLTemplate = "https://terraria.wiki.gg/wiki/Special:Search?search={searchTerms}";
                    SuggestURLTemplate = "https://terraria.wiki.gg/api.php?action=opensearch&search={searchTerms}";
                  }
                  {
                    Name = "Baldurs Gate wiki";
                    Alias = "gb";
                    IconURL = "https://bg3.wiki/favicon.ico";
                    URLTemplate = "https://bg3.wiki/w/index.php?search={searchTerms}";
                    SuggestURLTemplate = "https://bg3.wiki/w/api.php?action=opensearch&search={searchTerms}";
                  }
                  {
                    Name = "ProtonDB";
                    Alias = "gp";
                    IconURL = "https://www.protondb.com/sites/protondb/images/favicon.ico";
                    URLTemplate = "https://www.protondb.com/search?q={searchTerms}";
                  }
                ]
                else []
              );
          };
        };
      };
    };
  };
}
