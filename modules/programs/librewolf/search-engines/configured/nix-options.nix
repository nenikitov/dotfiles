{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "NixOS options Librewolf search engine";
      options = {lib, ...}: {
        channel = self.lib.option.mkChannelOption "NixOS system release version.";
      };
      config = {configModule, ...}: {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.nix-options = {
          name = "NixOS Options";
          icons."16" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
          aliases = ["@nix-options"];
          urls = {
            search = {
              url = "https://search.nixos.org/options";
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
