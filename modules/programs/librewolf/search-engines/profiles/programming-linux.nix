{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with programming (related to Linux) extensions";
      config = {
        ${self.lib.namespace}.programs.librewolf.searchEngines = {
          profiles.programming.enable = true;

          configured = {
            archPackages.enable = true;
            archWiki.enable = true;

            homeOptions.enable = true;
            homePackages.enable = true;
            nixOptions.enable = true;
            nixPackages.enable = true;
            nixWiki.enable = true;

            noogle.enable = true;

            nerdFonts.enable = true;
          };
        };
      };
    };
  };
}
