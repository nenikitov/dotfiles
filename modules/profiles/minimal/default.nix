{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with very minimal CLI functionality";
      config = {
        extra,
        lib,
        config,
        pkgs,
        ...
      }: {
        home = {
          username = extra.userName;
          homeDirectory = lib.mkDefault "/home/${config.home.username}";
          # TODO: Remove these
          packages = with pkgs; [ripgrep rofi];
        };

        nixpkgs.config.allowUnfree = true;

        programs.home-manager.enable = true;
        news.display = "silent";

        ${self.lib.namespace} = {
          settings.garbageCollection.enable = true;
        };
      };
    };
  };
}
