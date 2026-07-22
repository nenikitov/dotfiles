{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "support for network (via NetworkManager)";
      config = {
        networking.networkmanager.enable = true;
      };
    };
  };
}
