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
    # [Issue](https://github.com/nix-community/home-manager/issues/3075#issuecomment-3037360368).
    legacyPackages.homeConfigurations."${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        # Third pary
        # My own
        self.homeModules.profile_minimal
        self.homeModules.default
        module
      ];
      extraSpecialArgs = {
        inherit inputs;
        extra = {
          inherit userName hostName;
        };
      };
    };
  };
}
