{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "rofi application launcher";
      options = {
        isDefault.launcher = self.lib.option.mkBoolOption {
          description = "set rofi as default launcher";
          default = true;
        };
      };
      config = {
        configModule,
        lib,
        ...
      }: {
        programs.rofi = {
          enable = true;
        };

        ${self.lib.namespace}.settings.defaultApps = {
          launcher = lib.mkIf configModule.isDefault.launcher {
            exec = "rofi -show drun";
            desktop = "rofi.desktop";
          };
        };
      };
    };
  };
}
