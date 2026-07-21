{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Home packages Librewolf search engine";
      options = {lib, ...}: {
        channel = self.lib.option.mkChannelOption "nixpkgs channel that home-manager follows.";
      };
      config = {configModule, ...}: {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.home-packages = {
          name = "Home Packages";
          icons."16" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
          aliases = ["@home-packages"];
          urls = {
            search = {
              url = "https://search.nixos.org/packages";
              params = {
                query = "{searchTerms}";
                channel = configModule.channel;
              };
            };
          };
        };
      };
    };
  };
}
