{self, ...}: {
  perSystem = {pkgs, ...}:
    self.lib.mkHome {
      inherit pkgs;
      userName = "nenikitov";
      hostName = "nenikitov-pc-nix";
    } {
      # Do not change!
      # Corresponds to the first home-manager version installed on this machine.
      home.stateVersion = "25.05";
      _ne.test = {
        a.enable = true;
        b.enable = true;
      };
    };
}
