{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Home options Librewolf search engine";
      options = {lib, ...}: {
        channel = self.lib.option.mkChannelOption "home-manager release version.";
      };
      config = {configModule, ...}: {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.home-options = {
          name = "Home Options";
          icons."16" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
          aliases = ["@home-options"];
          urls = {
            search = {
              url = "https://search.nixos.org/options";
              params = {
                query = "{searchTerms}";
                channel = configModule.channel;
                source = "home_manager";
              };
            };
          };
        };
      };
    };
  };
}
