{self, ...}: {
  perSystem =
    self.lib.mkHome {
      userName = "nenikitov";
      hostName = "nenikitov-pc-nix";
    } {
      # Do not change!
      # Corresponds to the first home-manager version installed on this machine.
      home.stateVersion = "25.05";

      ${self.lib.namespace} = {
        profiles.graphical.enable = true;

        # TODO: Move to profile
        programs = {
          alacritty.enable = true;
          discord.enable = true;
          git.enable = true;
          neovim.enable = true;
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
}
