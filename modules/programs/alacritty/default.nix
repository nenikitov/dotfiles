{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Alacritty terminal emulator";
      options = {
        isDefault.terminal = self.lib.option.mkBoolOption {
          description = "set Alacritty as default terminal emulator";
          default = true;
        };
      };
      config = {
        configModule,
        lib,
        ...
      }: {
        programs.alacritty = {
          enable = true;
          settings = {
            # TODO: See if I like it if I use transparency
            # colors.transparent_background_colors = true;
            window = {
              dynamic_padding = true;
              padding = {
                x = 6;
                y = 6;
              };
            };
            selection.save_to_clipboard = true;
          };
        };

        ${self.lib.namespace}.settings.defaultApps = {
          terminal = lib.mkIf configModule.isDefault.terminal {
            exec = "alacritty";
            desktop = "Alacritty.desktop";
          };
        };
      };
    };
  };
}
