{lib, ...}: {
  imports = [
    ./search-engines
    ./settings
    ./extensions
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

      profiles.default = {
        isDefault = true;
      };
    };
  };

  # json = home.file.".mozilla/firefox/default/extension-preferences.json".text;
}
