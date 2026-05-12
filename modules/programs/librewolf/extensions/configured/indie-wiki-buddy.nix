{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Indie wiki buddy Librewolf extension.";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.indie-wiki-buddy;
            settings.sync = {
              notifications = false;
              breezewiki = "redirect";
            };
          }
        ];
      };
    };
  };
}
