{
  self,
  inputs,
  ...
}: {
  flake.lib.module = let
    getModuleConfigs = args: path: rec {
      inherit path;
      inherit (args) config;
      inherit (self.lib) namespace;
      configNamespace = config.${namespace};
      configModule = inputs.nixpkgs.lib.attrByPath path {} configNamespace;
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
          |> self.lib.function.applyIfFunction args
          |> inputs.nixpkgs.lib.setAttrByPath ([namespace] ++ resolvedPath);
        config =
          config
          |> self.lib.function.applyIfFunction ((getModuleConfigs args resolvedPath) // args);
      };
    };

    enableCheckSelf = args: args.configModule.enable;
    enableCheckSelfAndParent = parent: args:
      (enableCheckSelf args)
      && (inputs.nixpkgs.lib.setAttrByPath parent args.configNamespace).enable;

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
          (self.lib.function.applyIfFunction args options)
          // {
            enable = inputs.nixpkgs.lib.mkEnableOption description;
          };
        config = args:
          inputs.nixpkgs.lib.mkIf
          (enableCheck args)
          (self.lib.function.applyIfFunction args config);
      };
  };
}
