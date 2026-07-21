{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Spotify music player";
      config = {pkgs, ...}: {
        home.packages = with pkgs; [spotify];
      };
    };
  };
}
