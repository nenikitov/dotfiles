{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with programming extensions";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.configured = {
          github.enable = true;
          grep.enable = true;
        };
      };
    };
  };
}
