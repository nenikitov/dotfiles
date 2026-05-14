{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {
        lib,
        pkgs,
        ...
      }: let
        inherit (lib) types;
        searchEngineType = types.submodule {
          options = {
            url = lib.mkOption {
              description = "URL without parameters.";
              type = types.str;
            };
            params = {
              description = "GET parameters";
              type = types.attrsOf types.str;
            };
          };
        };
      in
        lib.mkOption {
          description = "List of search engines to add.";
          default = {};
          type = types.attrsOf (types.submodule {
            options = {
              name = lib.mkOption {
                description = "Displayed name.";
                type = types.str;
              };
              icons = lib.mkOption {
                description = "Icons (size to URL).";
                type = types.attrsOf types.str;
              };
              aliases = lib.mkOption {
                description = "Aliases.";
                type = types.listOf types.str;
                default = [];
              };
              urls = {
                search = lib.mkOption {
                  description = "Main search URL.";
                  type = searchEngineType;
                };
                suggestions = lib.mkOption {
                  description = "API for suggestions.";
                  type = types.nullOr searchEngineType;
                  default = null;
                };
              };
            };
          });
        };
      config = {
        configNamespace,
        configModule,
        lib,
        ...
      }: {
        programs.librewolf.profiles.${configNamespace.programs.librewolf._profileName}.search.engines =
          configModule
          |> builtins.mapAttrs (_: e: {
            inherit (e) name;
            iconMapObj = e.icons;
            definedAliases = e.aliases;
            urls = let
              mkUrl = url: {
                template = url.url;
                params = url.params |> lib.attrsToList;
              };
              search =
                e.urls.search
                |> mkUrl
                |> lib.singleton;
              suggestions =
                if e.urls.suggestions != null
                then
                  e.urls.suggestions
                  |> mkUrl
                  |> lib.singleton
                  |> (u: u // {type = "application/x-suggestions+json";})
                else [];
            in
              search ++ suggestions;
          });
      };
    };
  };
}
