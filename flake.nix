{
  description = "nenikitov's home configuration";

  inputs = {
    # Offical
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Community
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake
    {inherit inputs;} {
      debug = true;
      # Poor x86-64 Darwin :(
      systems = nixpkgs.lib.systems.flakeExposed |> nixpkgs.lib.subtractLists ["x86_64-darwin"];
      imports = [
        # Community
        inputs.home-manager.flakeModules.default
        # Personal
        # Local
        (import-tree [./lib ./parts ./modules ./homes])
      ];
    };
}
