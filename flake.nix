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
        # Third pary
        home-manager.flakeModules.default
        # My own
        (import-tree [./lib ./parts ./modules ./homes])
      ];
    };
}
