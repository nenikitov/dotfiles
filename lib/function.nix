{inputs, ...}: {
  flake.lib.function = let
    inherit (inputs.nixpkgs) lib;
  in {
    applyIfFunction = args: obj:
      if lib.isFunction obj
      then obj args
      else obj;
  };
}
