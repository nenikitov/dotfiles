{self, ...}: {
  flake = {
    homeModules.default = self.lib.mkEnableModule' {
      path = __curPos;
      description = "A test module `b`";
      config = {
        home.file."b.txt".text = "b.txt";
      };
    };
  };
}
