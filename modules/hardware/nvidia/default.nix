{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "support for Nvidia GPUs (via properietary drivers and open kernel module)";
      config = {
        services.xserver.videoDrivers = ["nvidia"];

        hardware.nvidia = {
          modesetting.enable = true;
          open = true;
        };

        # TODO: Test if needed, I think blender will install without CUDA
        nixpkgs.config.cudaSupport = true;
        nix.settings = {
          substituters = [ "https://cache.nixos-cuda.org" ];
          trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          ];
        };
      };
    };
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "support for Nvidia GPUs (via properietary drivers and open kernel module)";
      config = {
        # TODO: Test if needed, I think blender will install without CUDA
        nixpkgs.config.cudaSupport = true;
        nix.settings = {
          substituters = [ "https://cache.nixos-cuda.org" ];
          trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          ];
        };
      };
    };
  };
}
