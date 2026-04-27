{
  flake.lib.debug = rec {
    dbg' = valDbg: valRet: builtins.trace (builtins.deepSeq valDbg valDbg) valRet;
    dbg = val: dbg' val val;
  };
}
