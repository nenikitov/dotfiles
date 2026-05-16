{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Brave Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.brave = {
          name = "Brave Search";
          icons."32" = "https://cdn.search.brave.com/serp/v3/_app/immutable/assets/favicon-32x32.B2iBzfXZ.png";
          aliases = ["@b" "@brave"];
          urls = {
            search = {
              url = "https://search.brave.com/search";
              params = {
                q = "{searchTerms}";
              };
            };
            suggestions = {
              url = "https://search.brave.com/api/suggest";
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
