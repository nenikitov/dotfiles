{
  self,
  inputs,
  ...
}: {
  flake.lib.module = let
    inherit (inputs.nixpkgs) lib;

    getModuleConfigs = args: path: rec {
      inherit path;
      inherit (args) config;
      inherit (self.lib) namespace;
      configNamespace = config.${namespace};
      configModule = lib.attrByPath path {} configNamespace;
    };

    getModulePath = path:
      if builtins.isString path
      then
        # String
        [path]
      else if builtins.isAttrs path && path ? file
      then let
        # __curPos
        dirMatch =
          path.file
          |> builtins.match
          /*
          regex
          */
          ''^.*/modules/(.*)/default\.nix$'';
        nameMatch =
          path.file
          |> builtins.match
          /*
          regex
          */
          ''^.*/modules/(.*)\.nix$'';
        match =
          builtins.elemAt (
            if dirMatch != null
            then dirMatch
            else nameMatch
          )
          0;
      in
        match
        |> builtins.split "/"
        |> builtins.filter builtins.isString
        |> builtins.map (self.lib.case.convert {
          from = "kebab";
          to = "camel";
        })
      else
        # Array
        path;
  in rec {
    namespace = "_ne";

    mkModule = {
      path,
      options ? {},
      config ? {},
    }: let
      resolvedPath = getModulePath path;
    in {
      # HACK: Nix module dynamically determine which arguments to pass to avoid recursion.
      # So we "migrate" arguments from inner functions to the wrapper so arguments are visible from outside.
      # [Issue](https://github.com/NixOS/nixpkgs/issues/446068#issuecomment-3335305966)
      # [Snippet](https://github.com/NixOS/nixpkgs/blob/cd644aa397547e41b974c7c2f48aef83113bc19e/lib/modules.nix#L710)
      default = self.lib.function.migrateArgs [options config] (
        args: {
          ${
            if options != {}
            then "options"
            else null
          } =
            options
            |> self.lib.function.applyIfFunction args
            |> lib.setAttrByPath ([namespace] ++ resolvedPath);
          config =
            config
            |> self.lib.function.applyIfFunction ((getModuleConfigs args resolvedPath) // args);
        }
      );
    };

    enableCheckSelf = args: args.configModule.enable;
    enableCheckSelfAndParent = parent: args:
      (enableCheckSelf args)
      && (lib.setAttrByPath parent args.configNamespace).enable;

    mkEnableModule = {
      path,
      description,
      enableCheck ? enableCheckSelf,
      options ? {},
      config ? {},
    }:
      mkModule {
        inherit path;
        # HACK: Same arguments hack as before
        options = self.lib.function.migrateArgs options (
          args:
            (self.lib.function.applyIfFunction args options)
            // {
              enable = lib.mkEnableOption description;
            }
        );
        # HACK: Same arguments hack as before
        config = self.lib.function.migrateArgs config (
          args:
            lib.mkIf
            (enableCheck args)
            (self.lib.function.applyIfFunction args config)
        );
      };
  };
}
