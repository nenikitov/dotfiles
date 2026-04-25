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
        last = builtins.elemAt parts (length - 1);
      in
        if length > 1
        then [(singular first) last]
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

    moduleName = path: builtins.concatStringsSep "_" path;

    mkModule = {
      path,
      options ? {},
      config ? {},
    }: let
      pathModule = getModulePath path;
    in {
      ${moduleName pathModule} = args: {
        options.${namespace} =
          options
          |> self.lib.applyIfFunction args
          |> args.lib.setAttrByPath pathModule;
        config =
          config
          |> self.lib.applyIfFunction (getModuleConfigs args pathModule) // args;
      };
    };
  };
}
