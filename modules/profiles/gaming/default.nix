{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with games";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
          profiles.graphical.enable = true;
          programs.librewolf = {
            searchEngines.profiles.gaming.enable = true;
            extensions.profiles.gaming.enable = true;
          };
        };
      };
    };
  };
}
