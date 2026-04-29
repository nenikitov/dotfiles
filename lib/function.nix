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
        |> builtins.zipAttrsWith (k: v: builtins.any (v: v == true) v)
      );
  };
}
