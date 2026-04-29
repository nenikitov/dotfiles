{inputs, ...}: {
  flake.lib.function = let
    inherit (inputs.nixpkgs) lib;
  in {
    applyIfFunction = args: obj:
      if lib.isFunction obj
      then obj args
      else obj;

    migrateArgs = sources: fn:
      lib.setFunctionArgs
      fn
      (
        sources
        |> lib.toList
        |> (sources: sources ++ [fn])
        |> builtins.map (s:
          if lib.isFunction s
          then lib.functionArgs s
          else if (builtins.isAttrs s) && (s |> builtins.attrValues |> builtins.all builtins.isBool)
          then s
          else {})
        |> builtins.zipAttrsWith (k: v: builtins.any (v: v == true) v)
      );
  };
}
