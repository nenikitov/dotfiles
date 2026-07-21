{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with communication or light entertainment applications that I use almost daily";
      config = {
        ${self.lib.namespace} = {
          profiles.graphical.enable = true;
          programs = {
            discord.enable = true;
            spotify.enable = true;
          };
        };
      };
    };
  };
}
