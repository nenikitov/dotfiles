{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "temporary, hidden, and irreproducible part of the configuration";
      config = {
      };
    };
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "temporary, hidden, and irreproducible part of the configuration";
      config = {
      };
    };
  };
}
