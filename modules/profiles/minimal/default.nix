{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {path = __curPos;};
  };
}
