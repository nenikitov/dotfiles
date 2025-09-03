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
    lib = nixpkgs.lib;
    libModule = inputs.moduleUtils.lib;
    libHomeManager = inputs.homeManager.lib;
    libFlake = inputs.flakeUtils.lib;

    customNamespace = "_ne";

    hostsDir = "${self}/hosts";
    hosts = lib.pipe hostsDir [
      builtins.readDir
      (lib.concatMapAttrs (p: t:
        if t == "directory" then { "${p}" = p; }
        else if t == "regular" && lib.hasSuffix ".nix" p then { "${lib.removeSuffix ".nix" p}" = p; }
        else {}
      ))
      (builtins.mapAttrs (h: p: let
        parsed = builtins.split "@" h;
      in {
        module = "${hostsDir}/${p}";
        userName = builtins.elemAt parsed 0;
        hostName = builtins.elemAt parsed 1;
      }))
    ];

    mkHome = system: {module, userName, hostName}:
      libHomeManager.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          inputs.niri.homeModules.niri
          (self.homeManagerModules.default {namespace = customNamespace;})
          module
        ];
        extraSpecialArgs = {
          inherit inputs userName hostName customNamespace;
        };
      };
  in
    libFlake.eachSystem libFlake.allSystems (system: {
      packages.homeConfigurations = builtins.mapAttrs (_: mkHome system) hosts;
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
