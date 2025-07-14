{
  description = "nenikitov's home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakeUtils.url = "github:numtide/flake-utils";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    moduleUtils = {
      url = "github:nenikitov/nix-module-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    customNamespace = "_ne";

    lib = nixpkgs.lib;
    libModule = inputs.moduleUtils.lib;
    libHomeManager = inputs.homeManager.lib;
    libFlake = inputs.flakeUtils.lib;

    userHosts = [
      {userName = "nenikitov"; hostName = "nenikitov-pc-nix";}
      {userName = "nenikitov"; hostName = "nenikitov-laptop-nix";}
    ];
    mkHome = system: {userName, hostName}:
      libHomeManager.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          inputs.niri.homeModules.niri
          (self.homeManagerModules.default {namespace = customNamespace;})
          "${self}/hosts/${hostName}"
        ];
        extraSpecialArgs = {
          inherit inputs userName hostName customNamespace;
        };
      };
  in
    libFlake.eachSystem libFlake.allSystems (system: {
      packages.homeConfigurations =
        lib.pipe
        userHosts
        [
          (builtins.map ({userName, hostName}@userHost: {
            name = "${userName}@${hostName}";
            value = mkHome system userHost;
          }))
          builtins.listToAttrs
        ];
    })
    //
    {
      homeManagerModules.default = libModule.optionallyConfigureModule ({namespace ? "_ne"}:
        libModule.overlayModule {
          overlayArgs = args:
            args
            // {
              libModule = libModule.libModule {
                inherit namespace args;
              };
            };
        }
        ./modules);
    };
}
