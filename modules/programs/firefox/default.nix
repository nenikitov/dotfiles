{
lib,
mkModule,
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
        example = "DuckDuckGo";
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
    programs.firefox = {
      enable = true;

      policies = {
        SearchEngines = {
          PreventInstalls = true;
          Default = configModule.search.default;
          Remove = [
            "Amazon.com"
            "Bing"
            "Twitter"
            "eBay"
          ];
          Add = [
            {
              Name = "YouTube";
              Alias = "@y";
              IconURL = "https://www.youtube.com/s/desktop/2253fa3d/img/logos/favicon_144x144.png";
              Method = "GET";
              URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
            }
            {
              Name = "Brave Search";
              Alias = "@b";
              IconURL = "https://upload.wikimedia.org/wikipedia/commons/d/da/Brave_search_logo.png";
              Method = "GET";
              URLTemplate = "https://search.brave.com/search?q={searchTerms}";
              SuggestURLTemplate = "https://search.brave.com/api/suggest?q={searchTerms}";
            }
          ];
        };
      };
    };
  };
}
