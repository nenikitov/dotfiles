{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "NixOS wiki Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.nix-wiki = {
          name = "NixOS Wiki";
          icons."16" = "https://nixos.wiki/favicon.png";
          aliases = ["@nix-wiki"];
          urls = {
            search = {
              template = "https://nixos.wiki/index.php";
              params = {
                search = "{searchTerms}";
              };
            };
            suggestions = {
              template = "https://nixos.wiki/api.php";
              params = {
                search = "{searchTerms}";
                action = "opensearch";
              };
            };
          };
        };
      };
    };
  };
}
