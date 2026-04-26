{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule' {
      path = __curPos;
      description = "A test module `a`";
      config = {
        home.file."a.txt".text = "a.txt";
      };
    };
  };
}
