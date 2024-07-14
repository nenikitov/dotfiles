{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.searchEngines.custom = {
      nixPackages = lib.mkEnableOption "NixOS package search engine";
      nixOptions = lib.mkEnableOption "NixOS options search engine";
      nixWiki = lib.mkEnableOption "NixOS Wiki search engine";
      youTube = lib.mkEnableOption "YouTube search engine";
    };
  };

  config = let
    custom = config.ne.firefox.searchEngines.custom;
  in {
    programs.firefox.profiles.default.search.engines = {
      "NixOS Packages" = lib.mkIf custom.nixPackages {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "channel";
                value = "unstable";
              }
            ];
          }
        ];
        iconUpdateURL = "https://wiki.nixos.org/nixos.png";
        definedAliases = ["@np"];
      };
      "NixOS Options" = lib.mkIf custom.nixOptions {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        iconUpdateURL = "https://wiki.nixos.org/nixos.png";
        definedAliases = ["@no"];
      };
      "NixOS Wiki" = lib.mkIf custom.nixWiki {
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
        ];
        iconUpdateURL = "https://wiki.nixos.org/nixos.png";
        definedAliases = ["@nw"];
      };
      "YouTube" = lib.mkIf custom.youTube {
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
        ];
        iconUpdateURL = "https://www.youtube.com/s/desktop/252a8b44/img/favicon_144x144.png";
        definedAliases = ["@yt"];
      };
    };
  };
}
