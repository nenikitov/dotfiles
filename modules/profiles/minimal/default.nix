{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      config = {
        extra,
        lib,
        config,
        ...
      }: {
        home = {
          username = extra.userName;
          homeDirectory = lib.mkDefault "/home/${config.home.username}";
        };
      };
    };
  };
}
