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
      then [path]
      else if builtins.isAttrs path && builtins.hasAttr "file" path
      then let
        dir_match = builtins.match ''^.*/modules/(.*)/default\.nix$'' path.file;
        name_match = builtins.match ''^.*/modules/(.*)\.nix$'' path.file;
      in
        builtins.elemAt (
          if dir_match != null
          then dir_match
          else name_match
        )
        0
        |> builtins.split "/"
        |> builtins.filter (e: e != [])
      else path;

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
      pathModule = builtins.trace (getModulePath path) (getModulePath path);
    in {
      ${moduleName pathModule} = args: {
        options.${namespace} = args.lib.setAttrByPath pathModule options;
        config = self.lib.applyIfFunction config (getModuleConfigs args pathModule);
      };
    };
  };
}
