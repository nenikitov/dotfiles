{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with minimal extensions.";
      config = {
        ${self.lib.namespace}.programs.librewolf.extensions.configured = {
          indieWikiBuddy.enable = true;
        };
      };
    };
  };
}
