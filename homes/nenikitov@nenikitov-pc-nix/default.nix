{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: self.lib.mkHome {
    inherit pkgs;
    userName = "nenikitov";
    hostName = "nenikitov-pc-nix";
  } {
  };
}
