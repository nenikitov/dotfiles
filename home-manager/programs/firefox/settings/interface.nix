{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    ne.firefox.settings.interface = lib.mkEnableOption "interface-related settings";
  };

  config = lib.mkIf config.ne.firefox.settings.interface {
    programs.firefox = {
      package = pkgs.firefox-esr;
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
      };
        profiles.default = {
          settings = {
            # browser.backspace_action
            "findbar.highlightAll" = true;
            "svg.context-properties.content.enabled" = true;
            "browser.newtabpage.activity-stream.weather.temperatureUnits" = "c";
            # TODO(nenikitov): Remove this
            "xpinstall.signatures.required" = false;
          };
        };
    };
  };
}
