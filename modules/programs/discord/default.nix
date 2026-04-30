{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Discord chat application";
      config = {
        programs.discord = {
          enable = true;

          settings = {
            MIN_WIDTH = 0;
            MIN_HEIGHT = 0;
          };
        };
      };
    };
  };
}
