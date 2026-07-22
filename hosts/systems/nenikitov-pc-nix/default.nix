{self, ...}: {
  flake = {
    nixosConfigurations =
      self.lib.mkSystem {
        hostName = "nenikitov-pc-nix";
      } {
        imports =
          [
            ./_hardware.nix
          ]
          ++ self.lib.conditionalImport ./_temp.nix;

        # Do not change!
        # Corresponds to the first installed NixOS version
        system.stateVersion = "25.05";

        boot.loader.efi.canTouchEfiVariables = true;

        # TODO: Is there a way to not hardcode home path?
        fileSystems."/home/nenikitov/Shared" = {
          device = "/dev/disk/by-label/MyFiles_New";
          options = ["rw" "uid=1000"];
          fsType = "auto";
        };

        ${self.lib.namespace} = {
          profiles.graphical.enable = true;
          hardware.nvidia.enable = true;
          programs.systemdBoot.extraEntries = {
            "grub.conf" = ''
              title GRUB
              efi /EFI/GRUB/grubx64.efi
            '';
          };
        };

        time.timeZone = "America/Toronto";
        services.xserver.xkb = {
          layout = "us";
        };
      };
  };
}
