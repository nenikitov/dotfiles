{
  description = "nenikitov's home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefoxAddons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    moduleUtils = {
      url = "github:nenikitov/nix-module-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    generationTrimmer = {
      url = "github:nenikitov/nix-generation-trimmer";
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
    libTreefmt = inputs.treefmt.lib;

    forAllSystems = lib.genAttrs lib.systems.flakeExposed;

    customNamespace = "_ne";

    hostsDir = "${self}/hosts";
    hosts = lib.pipe hostsDir [
      builtins.readDir
      (lib.concatMapAttrs (
        p: t:
          if t == "directory"
          then {${p} = p;}
          else if t == "regular" && lib.hasSuffix ".nix" p
          then {${lib.removeSuffix ".nix" p} = p;}
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

    mkHome = system: {
      module,
      userName,
      hostName,
    }:
      libHomeManager.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          # Modules
          inputs.niri.homeModules.niri
          inputs.generationTrimmer.homeModules.default
          (self.homeModules.default {namespace = customNamespace;})
          # Config
          module
        ];
        extraSpecialArgs = {
          inherit inputs userName hostName customNamespace;
        };
      };

    mkTreefmt = system: (libTreefmt.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix);
  in {
    # NOTE: Even though it's packages, it's outputting homeConfigurations
    # Here is a [relevant issue](https://github.com/nix-community/home-manager/issues/3075#issuecomment-2646631773)
    packages = forAllSystems (system: {homeConfigurations = builtins.mapAttrs (_: mkHome system) hosts;});
    homeModules.default = libModule.optionallyConfigureModule ({namespace ? "_ne"}:
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

    formatter = forAllSystems (system: (mkTreefmt system).config.build.wrapper);
    checks = forAllSystems (system: {
      format = (mkTreefmt system).config.build.check self;
    });
  };
}
