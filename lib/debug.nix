{...}: {
  flake.lib = rec {
    debug' = dbg: ret: builtins.trace (builtins.deepSeq dbg dbg) ret;
    debug = val: debug' val val;
  };
}
