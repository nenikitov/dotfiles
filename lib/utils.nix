{...}: {
  flake.lib = {
    applyIfFunction = obj: args:
      if builtins.isFunction obj
      then obj args
      else obj;
  };
}
