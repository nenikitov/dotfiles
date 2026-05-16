{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a Librewolf profile with minimal extensions";
      config = {configNamespace, ...}: {
        ${self.lib.namespace}.programs.librewolf.searchEngines.configured = {
          brave.enable = true;
          startpage.enable = true;
          youtube.enable = true;
        };

        programs.librewolf.profiles.${configNamespace.programs.librewolf._profileName}.search.engines = {
          google.metaData.alias = "@g";
          ddg.metaData.alias = "@d";
          wikipedia.metaData.alias = "@w";
          bing.metaData.hidden = true;
        };
      };
    };
  };
}
