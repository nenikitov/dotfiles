{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.settings.interface = lib.mkEnableOption "interface-related settings";
  };

  config = lib.mkIf config.ne.firefox.settings.interface {
    programs.firefox = {
      policies = {
        DisplayMenuBar = "default-off";
        DisplayBookmarksToolbar = "never";
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        profiles.default = {
          settings = {
            "findbar.highlightAll" = true;
            "svg.context-properties.content.enabled" = true;
          };
        };
      };
    };
  };
}
