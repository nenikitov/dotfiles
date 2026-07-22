{
  self,
  inputs,
  lib,
  ...
}: {
  flake.lib.module = let
    # HACK: Nix module dynamically determinse which arguments to pass to avoid recursion.
    # So we "migrate" arguments from inner functions to the wrapper so arguments are visible from outside.
    # [Issue](https://github.com/NixOS/nixpkgs/issues/446068#issuecomment-3335305966)
    # [Snippet](https://github.com/NixOS/nixpkgs/blob/cd644aa397547e41b974c7c2f48aef83113bc19e/lib/modules.nix#L710)
    migrateModuleArgs = sources: fn:
      lib.setFunctionArgs
      fn
      (
        sources
        |> lib.toList
        |> (sources: sources ++ [fn])
        |> builtins.map (s:
          if lib.isFunction s
          then
            # Function - get args
            lib.functionArgs s
          else if (builtins.isAttrs s) && (s |> builtins.attrValues |> builtins.all builtins.isBool)
          then
            # Funcion arguments - use as is
            s
          else
            # Not a function - assume empty
            {})
        |> builtins.zipAttrsWith (k: v: builtins.all (v: v == true) v)
        # Strip arguments my module system provides (see `getModuleArgs` because Nix modules shouldn't be concerned with them)
        |> lib.flip builtins.removeAttrs ["path" "configNamespace" "configModule"]
      );

    getModuleArgs = args: path:
      rec {
        inherit path;
        configNamespace = args.config.${self.lib.module.namespace};
        configModule = lib.attrByPath path {} configNamespace;
      }
      // args;

    getModulePath = path:
      if builtins.isString path
      then
        # String
        [path]
      else if builtins.isAttrs path && path ? file
      then
        # __curPos
        let
          dirMatch =
            path.file
            |> builtins.match
            # regex
            ''^.*/modules/(.*)/default\.nix$'';
          nameMatch =
            path.file
            |> builtins.match
            # regex
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
          |> builtins.map (self.lib.string.convertCase {
            from = "kebab";
            to = "camel";
          })
      else
        # Array
        path;
  in rec {
    namespace = "_ne";

    conditionalImport = path: lib.optional (builtins.pathExists path) path;

    mkModule = {
      path,
      options ? {},
      config ? {},
    }: let
      resolvedPath = getModulePath path;
    in {
      default = migrateModuleArgs [options config] (
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
            |> self.lib.function.applyIfFunction (getModuleArgs args resolvedPath);
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
        options = migrateModuleArgs options (
          args:
            (self.lib.function.applyIfFunction args options)
            // {
              enable = lib.mkEnableOption description;
            }
        );
        config = migrateModuleArgs config (
          args:
            lib.mkIf
            (enableCheck args)
            (self.lib.function.applyIfFunction args config)
        );
      };
  };
}
