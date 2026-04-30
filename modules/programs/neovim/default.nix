{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Neovim text editor";
      options = {
        isDefault.textEditor = {
          terminal = self.lib.option.mkBoolOption {
            description = "set Neovim as default terminal text editor";
            default = true;
          };
          # TODO: Provide a GUI editor too
        };
      };
      config = {
        configModule,
        lib,
        ...
      }: {
        programs.neovim = {
          enable = true;
          withNodeJs = true;
          withPython3 = true;
          extraConfig =
            # viml
            ''
              set nu rnu nowrap
              map H ^
              map L $
            '';
        };

        ${self.lib.namespace}.settings.defaultApps = {
          textEditor = {
            terminal = lib.mkIf configModule.isDefault.textEditor.terminal {
              exec = "nvim";
              desktop = "nvim.desktop";
            };
          };
        };
      };
    };
  };
}
