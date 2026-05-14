{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Search by image Librewolf extension";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.search-by-image;
          }
        ];
      };
    };
  };
}
