{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "YouTube Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.youtube = {
          name = "YouTube";
          icons."16" = "https://youtube.com/favicon.ico";
          aliases = ["@y" "@youtube"];
          urls = {
            search = {
              template = "https://www.youtube.com/results";
              params = {
                search_query = "{searchTerms}";
              };
            };
            suggestions = {
              template = "ttps://www.google.com/complete/search";
              params = {
                q = "{searchTerms}";
                ds = "yt";
                output = "firefox";
              };
            };
          };
        };
      };
    };
  };
}
