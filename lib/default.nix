{self, ...}: {
  flake.lib = {
    inherit
      (self.lib.debug)
      dbg'
      dbg
      ;

    inherit
      (self.lib.home)
      mkHome
      ;

    inherit
      (self.lib.module)
      namespace
      mkModule
      mkEnableModule
      ;
  };
}
