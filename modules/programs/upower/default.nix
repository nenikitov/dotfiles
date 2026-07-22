{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Upower power management service";
      config = {
        # TODO: Look into TLP
        services.upower = {
          enable = true;
        };
      };
    };
  };
}
