{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "ProtonDB Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.proton-db = {
          name = "ProgonDB";
          icons."48" = "https://www.protondb.com/favicon.ico";
          aliases = ["@proton-db"];
          urls = {
            search = {
              url = "https://www.protondb.com/search";
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
