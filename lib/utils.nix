{...}: {
  flake.lib = {
    applyIfFunction = args: obj:
      if builtins.isFunction obj
      then obj args
      else obj;
  };
}
