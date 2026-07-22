{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "systemd-boot bootloader";
      options = {options, ...}: {
        extraEntries = options.boot.loader.systemd-boot.extraEntries;
      };
      config = {configModule, ...}: {
        boot.loader.systemd-boot = {
          enable = true;
          editor = false;
          consoleMode = "max";
          extraEntries = configModule.extraEntries;
        };
      };
    };
  };
}
