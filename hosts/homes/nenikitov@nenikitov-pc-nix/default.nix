{self, ...}: {
  perSystem = args: {
    homeConfigurations =
      self.lib.mkHome args {
        userName = "nenikitov";
        hostName = "nenikitov-pc-nix";
      } {
        # Do not change!
        # Corresponds to the first home-manager version installed on this machine.
        home.stateVersion = "25.05";

        ${self.lib.namespace} = {
          hardware.nvidia.enable = true;

          profiles = {
            graphical.enable = true;
            daily.enable = true;
            dev.enable = true;
            devLinux.enable = true;
            gaming.enable = true;
          };

          settings = {
            monitors = [
              {
                name = "Ancor Communications Inc MG248 G9LMQS024781";
                primary = true;
                mode = {
                  width = 1920;
                  height = 1080;
                  refresh = 143.981;
                };
                position = {
                  x = 0;
                  y = 0;
                };
              }
              {
                name = "ASUSTek COMPUTER INC VG245 KCLMQS015128";
                mode = {
                  width = 1920;
                  height = 1080;
                  refresh = 75.001;
                };
                position = {
                  x = 1920;
                  y = 0;
                };
              }
            ];
          };
        };
      };
  };
}
