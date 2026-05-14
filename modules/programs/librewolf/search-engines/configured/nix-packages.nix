{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "NixOS packages Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.nix-packages = {
          name = "NixOS Packages";
          icons."16" = "ttps://search.nixos.org/favicon.png";
          aliases = ["@nix-packages"];
          urls = {
            search = {
              template = "https://search.nixos.org/packages";
              params = {
                query = "{searchTerms}";
                # TODO: Get from `pkgs` instead of hard coding.
                channel = "unstable";
              };
            };
          };
        };
      };
    };
  };
}
