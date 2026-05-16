{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Nerd Fonts Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.nerd-fonts = {
          name = "Nerd Fonts";
          icons."16" = "https://www.nerdfonts.com/assets/img/favicon.ico";
          aliases = ["@nerd-fonts"];
          urls = {
            search = {
              url = "https://www.nerdfonts.com/cheat-sheet";
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
