{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Adaptive tab bar color Librewolf extension.";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.adaptive-tab-bar-colour;
          }
        ];
      };
    };
  };
}
