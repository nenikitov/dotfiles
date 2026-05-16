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
          icons."16" = "https://search.nixos.org/favicon.png";
          aliases = ["@home-options"];
          urls = {
            search = {
              url = "https://home-manager-options.extranix.com";
              params = {
                query = "{searchTerms}";
                channel =
                  if configModule.channel == "unstable"
                  then "master"
                  else configModule.channel;
              };
            };
          };
        };
      };
    };
  };
}
