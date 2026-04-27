{
  self,
  inputs,
  ...
}: {
  flake.lib = let
    getModuleConfigs = args: path: rec {
      inherit path;
      inherit (args) config;
      inherit (self.lib) namespace;
      configNamespace = config.${namespace};
      configModule = args.lib.attrByPath path {} configNamespace;
    };

    getModulePath = path:
      if builtins.isString path
      then
        # String
        [path]
      else if builtins.isAttrs path && path ? file
      then let
        # __curPos
        dirMatch = path.file |> builtins.match ''^.*/modules/(.*)/default\.nix$'';
        nameMatch = path.file |> builtins.match ''^.*/modules/(.*)\.nix$'';
        match =
          builtins.elemAt (
            if dirMatch != null
            then dirMatch
            else nameMatch
          )
          0;
      in
        match |> builtins.split "/" |> builtins.filter builtins.isString
      else
        # Array
        path;

    toList = x:
      if builtins.isList x
      then x
      else [x];
  in rec {
    namespace = "_ne";

    mkModule = {
      path,
      options ? {},
      config ? {},
    }: let
      resolvedPath = getModulePath path;
    in {
      default = args: {
        ${
          if options != {}
          then "options"
          else null
        } =
          options
          |> self.lib.applyIfFunction args
          |> args.lib.setAttrByPath ([namespace] ++ resolvedPath);
        config =
          config
          |> self.lib.applyIfFunction ((getModuleConfigs args resolvedPath) // args);
      };
    };

    enableCheckSelf = args: args.configModule.enable;
    enableCheckSelfAndParent = parent: args:
      (enableCheckSelf args)
      && (args.lib.setAttrByPath parent args.configNamespace).enable;

    mkEnableModule = {
      path,
      description,
      enableCheck ? enableCheckSelf,
      options ? {},
      config ? {},
    }:
      mkModule {
        inherit path;
        options = args:
          (self.lib.applyIfFunction args options)
          // {
            enable = args.lib.mkEnableOption description;
          };
        config = args:
          args.lib.mkIf
          (enableCheck args)
          (self.lib.applyIfFunction args config);
      };
  };
}
