{
  lib,
  libModule,
  pkgs,
  ...
}:
# {
#   imports = [ ./search-engines.nix ];
# }
# //
libModule.mkEnableModule {
  path = ["programs" "librewolf"];
  description = "Librewolf (Firefox fork) web-browser";
  options = {
    search = {
      linux = {
        enable = lib.mkEnableOption "Linux related search engines" // {default = true;};
        nixosChannel = lib.mkOption {
          description = "Channel that NixOS system follows";
          default = "unstable";
          example = "25.05";
          type = lib.types.str;
        };
        homeChannel = lib.mkOption {
          description = "Channel that Home Manager follows";
          default = "unstable";
          example = "25.05";
          type = lib.types.str;
        };
      };
    };
  };
  config = {configModule, ...}: {
    programs.firefox.enable = true;

    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        extraPolicies = {
          # HACK: This breaks the entire policy settings section related to search engines
          # which prevents Librewolf from automatically resetting the search engine to DuckDuckGo
          # so we can set it with `profile.<profile>.search.default`.
          SearchEngines.Default = null;
        };
      };
      profiles.default = {
        name = "Default";
        isDefault = true;

        search = {
          force = true;
          default = "brave";

          engines =
            (
              if configModule.search.linux.enable
              then {
                nix-pkgs = {
                  name = "NixOS Packages";
                  iconMapObj."16" = "https://search.nixos.org/favicon.png";
                  definedAliases = ["@np" "@nix-pkgs"];
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "channel";
                          value = configModule.search.linux.nixosChannel;
                        }
                      ];
                    }
                  ];
                };

                nix-wiki = {
                  name = "NixOS Wiki";
                  iconMapObj."16" = "https://nixos.wiki/favicon.png";
                  definedAliases = ["@nw" "@nix-wiki"];
                  urls = [
                    {
                      template = "https://nixos.wiki/index.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                    {
                      type = "application/x-suggestions+json";
                      template = "https://nixos.wiki/api.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                        {
                          name = "action";
                          value = "opensearch";
                        }
                      ];
                    }
                  ];
                };

                nix-options = {
                  name = "NixOS Options";
                  iconMapObj."16" = "https://search.nixos.org/favicon.png";
                  definedAliases = ["@no" "@nix-options"];
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "channel";
                          value = configModule.search.linux.nixosChannel;
                        }
                      ];
                    }
                  ];
                };

                home-pkgs = {
                  name = "Home Packages";
                  iconMapObj."16" = "https://search.nixos.org/favicon.png";
                  definedAliases = ["@np" "@nix-pkgs"];
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "channel";
                          value = configModule.search.linux.homeChannel;
                        }
                      ];
                    }
                  ];
                };

                home-options = {
                  name = "Home Options";
                  iconMapObj."16" = "https://search.nixos.org/favicon.png";
                  definedAliases = ["@ho" "@home-options"];
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value =
                            if configModule.search.linux.homeChannel == "unstable"
                            then "master"
                            else configModule.search.linux.homeChannel;
                        }
                      ];
                    }
                  ];
                };
              }
              else {}
            )
            // {
              startpage = {
                name = "Startpage";
                iconMapObj."16" = "https://www.startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
                definedAliases = ["@s" "@startpage"];
                urls = [
                  {
                    template = "https://www.startpage.com/sp/search";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                  {
                    type = "application/x-suggestions+json";
                    template = "https://www.startpage.com/osuggestions";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };

              brave = {
                name = "Brave Search";
                iconMapObj."32" = "https://cdn.search.brave.com/serp/v3/_app/immutable/assets/favicon-32x32.B2iBzfXZ.png";
                definedAliases = ["@b" "@brave"];
                urls = [
                  {
                    template = "https://search.brave.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                  {
                    type = "application/x-suggestions+json";
                    template = "https://search.brave.com/api/suggest";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };

              youtube = {
                name = "YouTube";
                iconMapObj."16" = "https://youtube.com/favicon.ico";
                definedAliases = ["@y" "@youtube"];
                urls = [
                  {
                    template = "https://www.youtube.com/results";
                    params = [
                      {
                        name = "search_query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                  {
                    type = "application/x-suggestions+json";
                    template = "https://www.google.com/complete/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                      {
                        name = "ds";
                        value = "yt";
                      }
                      {
                        name = "output";
                        value = "firefox";
                      }
                    ];
                  }
                ];
              };

              google.metaData.alias = "@g";
              ddg.metaData.alias = "@d";
              wikipedia.metaData.alias = "@w";

              bing.metaData.hidden = true;
            };
        };

        settings = {
          "webgl.disabled" = false;
          "browser.startup.page" = 3;
          "browser.translations.automaticallyPopup" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "media.eme.enabled" = true;
          "general.autoScroll" = true;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.search.suggest.enabled" = true;
          "browser.search.suggest.enabled.private" = true;
          "browser.urlbar.suggest.searches" = true;
          "privacy.trackingprotection.allow_list.baseline.enabled" = false;
          "browser.formfill.enable" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "permissions.default.desktop-notification" = 2;
          "extensions.update.autoUpdateDefault" = false;
          "middlemouse.paste" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "privacy.resistFingerprinting" = false;
          "browser.tabs.inTitlebar" = 0;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.uidensity" = 1;
          "browser.compactmode.show" = true;
          "browser.urlbar.shortcuts.actions" = false;
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.shortcuts.bookmarks" = false;
        };
      };
    };
  };
}
