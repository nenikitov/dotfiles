{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "GitHub Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.github = {
          name = "GitHub";
          icons."32" = "https://github.com/favicon.ico";
          aliases = ["@github"];
          urls = {
            search = {
              url = "https://github.com/search";
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
