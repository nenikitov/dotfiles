{self, ...}: {
  perSystem =
    self.lib.mkHome {
      userName = "nenikitov";
      hostName = "nenikitov-laptop-nix";
    } {
      # Do not change!
      # Corresponds to the first home-manager version installed on this machine.
      home.stateVersion = "24.05";

      ${self.lib.namespace} = {
        profiles = {
          graphical.enable = true;
          daily.enable = true;
          dev.enable = true;
          devLinux.enable = true;
        };
      };
    };
}
