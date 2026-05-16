{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "PCGamingWiki Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.pc-gaming-wiki = {
          name = "PCGamingWiki";
          icons."64" = "https://static.pcgamingwiki.com/favicons/pcgamingwiki.png";
          aliases = ["@pc-gaming-wiki"];
          urls = {
            search = {
              url = "https://www.pcgamingwiki.com/w/index.php";
              params = {
                search = "{searchTerms}";
              };
            };
            suggestions = {
              url = "https://www.pcgamingwiki.com/w/api.php";
              params = {
                search = "{searchTerms}";
                action = "opensearch";
              };
            };
          };
        };
      };
    };
  };
}
