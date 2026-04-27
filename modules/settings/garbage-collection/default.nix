{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "automatic periodic garbage collection";
      config = {
        nix.gc = {
          automatic = true;
          dates = "daily";

          generationTrimmer = {
            enable = true;
            keepAtLeast = 10;
            keepAtMost = 100;
            olderThan = "1 month";
          };
        };
      };
    };
  };
}
