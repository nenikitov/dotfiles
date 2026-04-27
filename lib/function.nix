{...}: {
  flake.lib.function = {
    applyIfFunction = args: obj:
      if builtins.isFunction obj
      then obj args
      else obj;
  };
}
