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
        parts = match |> builtins.split "/" |> builtins.filter builtins.isString;
        singular = s:
          {
            # TODO: Add more top level module names
            "profiles" = "profile";
            "settings" = "setting";
            "programs" = "program";
          }."${s}" or s;
        length = builtins.length parts;
        first = builtins.head parts;
      in
        if length > 1
        then [(singular first)] ++ builtins.tail parts
        else [first]
      else
        # Array
        path;

    toList = x:
      if builtins.isList x
      then x
      else [x];
  in rec {
    namespace = "_ne";

    getModuleName = path: builtins.concatStringsSep "_" path;

    mkModule = {
      path,
      imports ? [],
      options ? {},
      config ? {},
    }: let
      resolvedPath = getModulePath path;
    in {
      ${getModuleName resolvedPath} = args: {
        inherit imports;
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

    mkModule' = {
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

    mkEnableModule' = {
      path,
      description,
      options ? {},
      config ? {},
    }:
      mkModule' {
        inherit path;
        options = args:
          (self.lib.applyIfFunction args options)
          // {
            enable = args.lib.mkEnableOption description;
          };
        config = args:
          args.lib.mkIf
          args.configModule.enable
          (self.lib.applyIfFunction args config);
      };
  };
}
