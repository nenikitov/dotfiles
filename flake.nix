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
    ...
  } @ inputs:
    flake-parts.lib.mkFlake
    {inherit inputs;} {
      debug = true;
      systems = ["x86_64-linux"];
      imports = [
        home-manager.flakeModules.home-manager
        (import-tree [./lib /* ./modules */ ./homes])
      ];
    };
}
