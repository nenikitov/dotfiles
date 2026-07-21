{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "NixOS packages Librewolf search engine";
      options = {lib, ...}: {
        channel = self.lib.option.mkChannelOption "nixpkgs channel that NixOS system follows.";
      };
      config = {configModule, ...}: {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.nix-packages = {
          name = "NixOS Packages";
          icons."16" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
          aliases = ["@nix-packages"];
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
