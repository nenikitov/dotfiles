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
        profiles.graphical.enable = true;

        # TODO: Move to profile
        programs = {
          alacritty.enable = true;
          discord.enable = true;
          git.enable = true;
          neovim.enable = true;
        };
      };
    };
}
