{
  description = "nenikitov's home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakeUtils.url = "github:numtide/flake-utils";

    moduleUtils = {
      url = "github:nenikitov/nix-module-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    homeManager,
    moduleUtils,
    flakeUtils,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    userHosts = [
      {userName = "nenikitov"; hostName = "nenikitov-pc-nix";}
      {userName = "nenikitov"; hostName = "nenikitov-laptop-nix";}
    ];
    customNamespace = "_ne";
    mkHome = system: {userName, hostName}:
      homeManager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          (self.homeManagerModules.default {namespace = customNamespace;})
          "${self}/hosts/${hostName}"
        ];
        extraSpecialArgs = {
          inherit inputs userName hostName customNamespace;
        };
      };
  in
    flakeUtils.lib.eachSystem flakeUtils.lib.allSystems (system: {
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
      homeManagerModules.default = moduleUtils.lib.optionallyConfigureModule ({namespace ? "_ne"}:
        moduleUtils.lib.overlayModule {
          overlayArgs = args:
            args
            // {
              libModule = moduleUtils.lib.libModule {
                inherit namespace args;
              };
            };
        }
        ./modules);
    };
}
