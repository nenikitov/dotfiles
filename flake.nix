{
  description = "nenikitov's home configuration";

  inputs = {
    # First party
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Third pary
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own
    generation-trimmer = {
      url = "github:nenikitov/nix-generation-trimmer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    home-manager,
    import-tree,
    nixpkgs,
    treefmt,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake
    {inherit inputs;} {
      debug = true;
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        home-manager.flakeModules.default
        # TODO: Move to a separate file
        ({
          lib,
          flake-parts-lib,
          moduleLocation,
          ...
        }: {
          options.flake = flake-parts-lib.mkSubmoduleOptions {
            lib = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = {};
              description = ''
                Library functions or constants exposed by the flake.
              '';
            };
          };
        })
        (import-tree [./lib ./modules ./homes])
        ./treefmt.nix
      ];
    };
}
