{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with software for development";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
          programs = {
            git.enable = true;
            neovim.enable = true;
            librewolf.searchEngines.profiles.dev.enable = true;
          };
        };
      };
    };
  };
}
