{self, ...}: {
  perSystem = {pkgs, ...}:
    self.lib.mkHome {
      inherit pkgs;
      userName = "nenikitov";
      hostName = "nenikitov-pc-nix";
    } ({
      userName,
      config,
      ...
    }: {
      # Do not change!
      # Corresponds to the first home-manager version installed on this machine.
      home.stateVersion = "25.05";
      home = {
        username = userName;
        homeDirectory = "/home/${config.home.username}";
      };
    });
}
