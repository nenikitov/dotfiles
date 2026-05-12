{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with minimal extensions.";
      config = {
        ${self.lib.namespace}.programs.librewolf.extensions.configured = {
          adaptiveTabBarColor.enable = true;
          darkReader.enable = true;
          returnYoutubeDislikes.enable = true;
          searchByImage.enable = true;
          sponsorblock.enable = true;
          ublock.enable = true;
        };
      };
    };
  };
}
