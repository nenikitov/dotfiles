{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "grep.app Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.grep = {
          name = "grep.app";
          icons."32" = "https://grep.app/icon.png";
          aliases = ["@grep"];
          urls = {
            search = {
              url = "https://grep.app/search";
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
