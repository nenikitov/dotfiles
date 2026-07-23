{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "LY display manager";
      config = {
        services.displayManager.ly = {
          enable = true;
          settings = {
            clear_password = true;
          };
        };
      };
    };
  };
}
