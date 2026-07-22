{self, ...}: {
  flake.lib = {
    inherit
      (self.lib.debug)
      dbg'
      dbg
      ;

    inherit
      (self.lib.host)
      mkHome
      mkSystem
      ;

    inherit
      (self.lib.module)
      namespace
      mkModule
      mkEnableModule
      ;
  };
}
