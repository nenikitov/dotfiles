{
  description = "nenikitov's home configuration";

  inputs = {
    # Offical
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Community
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

    # Personal
    generation-trimmer = {
      url = "github:nenikitov/nix-generation-trimmer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake
    {inherit inputs;} {
      debug = true;
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      imports = [
        # Third pary
        inputs.home-manager.flakeModules.default
        # My own
        (import-tree [./lib ./parts ./modules ./homes])
      ];
    };
}
