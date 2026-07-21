{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with software for Linux development";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
          profiles.dev.enable = true;
          programs = {
            librewolf.searchEngines.profiles.devLinux.enable = true;
          };
        };
      };
    };
  };
}
