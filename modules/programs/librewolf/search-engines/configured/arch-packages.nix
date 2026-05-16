{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Arch packages Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.arch-packages = {
          name = "Arch Packages";
          icons."16" = "https://archlinux.org/favicon.ico";
          aliases = ["@arch-packages"];
          urls = {
            search = {
              url = "https://archlinux.org/packages";
              params = {
                q = "{searchTerms}";
              };
            };
          };
        };
      };
    };
  };
}
