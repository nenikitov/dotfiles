{
  self,
  inputs,
  ...
}: {
  flake.lib.mkHome = {
    pkgs,
    userName,
    hostName,
  }: module: {
    # HACK: `flake.homeConfigurations` needs pkgs, so I'll need to hard-code it.
    # Even though I'm outputting a package, home-manager still checks for packages.<system>.homeConfigurations.<name> and accepts it.
    # [Relevant issue](https://github.com/nix-community/home-manager/issues/3075#issuecomment-3037360368).
    legacyPackages.homeConfigurations."${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        #self.homeModules.profile_minimal
        module
      ];
      extraSpecialArgs = {
        inherit inputs userName hostName;
      };
    };
  };
}
