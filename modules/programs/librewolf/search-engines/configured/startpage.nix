{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Startpage Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.startpage = {
          name = "Startpage";
          icons."64" = "https://www.startpage.com/favicon.ico";
          aliases = ["@s" "@startpage"];
          urls = {
            search = {
              template = "https://www.startpage.com/sp/search";
              params = {
                query = "{searchTerms}";
              };
            };
            suggestions = {
              template = "https://www.startpage.com/osuggestions";
              params = {
                q = "{searchTerms}";
              };
            };
          };
        };
      };
    };
  };
}
