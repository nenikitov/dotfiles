{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Dark reader Librewolf extension.";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.darkreader;
            settings.sync = {
              fetchNews = false;
              automation = {
                enabled = true;
                mode = "system";
              };
            };
          }
        ];
      };
    };
  };
}
