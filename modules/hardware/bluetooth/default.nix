{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "support for bluetooth (via bluez)";
      config = {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General.Experimental = true;
          };
        };
      };
    };
  };
}
