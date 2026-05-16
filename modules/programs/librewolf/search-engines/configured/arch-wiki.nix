{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Arch wiki Librewolf search engine";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines.searchEngines.arch-wiki = {
          name = "Arch Wiki";
          icons."16" = "https://wiki.archlinux.org/favicon.ico";
          aliases = ["@arch-wiki"];
          urls = {
            search = {
              url = "https://wiki.archlinux.org";
              params = {
                search = "{searchTerms}";
              };
            };
            suggestions = {
              url = "https://wiki.archlinux.org/api.php";
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
