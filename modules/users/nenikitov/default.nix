{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "creation of a `nenikitov` user profile";
      config = {
        users.users.nenikitov = {
          isNormalUser = true;
          description = "Myk";
          extraGroups = ["networkmanager" "wheel"];
        };
      };
    };
  };
}
