{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "support for printing (via cups)";
      config = {
        services.printing.enable = true;
      };
    };
  };
}
