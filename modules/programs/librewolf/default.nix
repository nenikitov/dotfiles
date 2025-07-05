{
  lib,
  mkModule,
  ...
}:
mkModule {
  path = ["programs" "librewolf"];
  description = "Librewolf (Firefox fork) web-browser";
  options = {
    searchEngines = {
      default = lib.mkOption {
        description = "Deafult search engine to use for regular windows.";
        default = "brave";
        example = "ddg";
        type = lib.types.str;
      };
      defaultPrivate = lib.mkOption {
        description = "Deafult search engine to use for private windows.";
        default = "brave";
        example = "ddg";
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
    };
  };
  config = {configModule, ...}: {
    programs.firefox.enable = true;
    programs.librewolf = {
      enable = true;

      profiles.default.search = {
        enable = true;
        force = true;
        default = builtins.trace configModule.searchEngines.default configModule.searchEngines.default;
        privateDefault = configModule.searchEngines.defaultPrivate;
        engines = lib.mkMerge [
          # Alias defaults
          {
            ddg.metaData.alias = "@d";
            wikipedia.metaData.alias = "@w";
            "policy-StartPage".metaData.alias = "@s";
          }
          # Hide useless
          {
            "policy-DuckDuckGo Lite".metaData.hidden = true;
            "policy-MetaGer".metaData.hidden = true;
            "policy-Mojeek".metaData.hidden = true;
            "policy-SearXNG - searx.be".metaData.hidden = true;
            "google".metaData.hidden = true;
            "bing".metaData.hidden = true;
          }
          # Custom
          {
            brave = {
              name = "Brave Search";
              icon = "https://upload.wikimedia.org/wikipedia/commons/d/da/Brave_search_logo.png";
              definedAliases = ["@b" "@brave"];
              urls = [{
                template = "https://search.brave.com/search";
                params = [
                  {name = "q"; value = "{searchTerms}";}
                ];
              }];
            };
            youtube = {
              name = "YouTube";
              icon = "https://www.youtube.com/s/desktop/2253fa3d/img/logos/favicon_144x144.png";
              definedAliases = ["@y" "@youtube"];
              urls = [{
                template = "https://www.youtube.com/results";
                params = [
                  {name = "search_query"; value = "{searchTerms}";}
                ];
              }];
            };
          }
        ];
      };
    };
  };
}
