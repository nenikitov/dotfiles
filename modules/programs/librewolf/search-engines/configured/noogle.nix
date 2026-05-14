{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Noogle Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.noogle = {
          name = "Noogle";
          icons."16" = "https://noogle.dev/favicon.png";
          aliases = ["@noogle"];
          urls = {
            search = {
              template = "https://noogle.dev/q";
              params = {
                term = "{searchTerms}";
              };
            };
          };
        };
      };
    };
  };
}
