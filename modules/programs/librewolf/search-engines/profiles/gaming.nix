{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with game-related extensions";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.configured = {
          pcGamingWiki.enable = true;
          protonDb.enable = true;
        };
      };
    };
  };
}
