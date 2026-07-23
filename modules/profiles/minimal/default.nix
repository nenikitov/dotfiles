{self, inputs, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with very minimal CLI functionality";
      config = {
        extra,
        lib,
        config,
        pkgs,
        ...
      }: {
        home = {
          username = extra.userName;
          homeDirectory = lib.mkDefault "/home/${config.home.username}";
          packages = with pkgs; [
            ripgrep
            btop
          ];
        };

        nixpkgs.config.allowUnfree = true;

        programs.home-manager.enable = true;
        news.display = "silent";

        ${self.lib.namespace} = {
          settings.garbageCollection.enable = true;
        };
      };
    };
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with very minimal CLI functionality";
      config = {
        extra,
        lib,
        config,
        pkgs,
        ...
      }: {
        nix = {
          # Necessary features to enable flakes
          settings.experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          # Make nix3 and legacy commands consistent with flakes
          registry = inputs
              |> lib.filterAttrs (k: v: lib.isType "flake" v)
              |> lib.mapAttrs (k: flake: {inherit flake;});
          nixPath = lib.mapAttrsToList (k: v: "${k}=${v.to.path}") config.nix.registry;
        };

        ${self.lib.namespace} = {
          settings = {
            garbageCollection.enable = true;
            numlockTty.enable = true;
          };
          programs = {
            ly.enable = true;
            systemdBoot.enable = true;
            upower.enable = true;
          };
          hardware = {
            network.enable = true;
            nuphy.enable = true;
          };
          users = {
            nenikitov.enable = true;
          };
        };

        networking = {inherit (extra) hostName;};

        boot.supportedFilesystems.ntfs = true;

        documentation.nixos.includeAllModules = true;

        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          file
          git
          tree
          vim
        ];
        programs.nix-ld.enable = true;
      };
    };
  };
}
