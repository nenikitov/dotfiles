{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Return YouTube dislikes Librewolf extension";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.return-youtube-dislikes;
          }
        ];
      };
    };
  };
}
