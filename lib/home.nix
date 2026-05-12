{
  self,
  inputs,
  ...
}: {
  flake.lib.home = {
    mkHome = {
      userName,
      hostName,
    }: module: {
      pkgs,
      self',
      inputs',
      ...
    }: {
      # HACK: `flake.homeConfigurations` needs pkgs, so I'll need to hard-code it.
      # Even though I'm outputting a package, home-manager still checks for packages.<system>.homeConfigurations.<name> and accepts it.
      # [Issue](https://github.com/nix-community/home-manager/issues/3075#issuecomment-3037360368).
      legacyPackages.homeConfigurations."${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # Community
          # Personal
          inputs.generation-trimmer.homeModules.default
          # Local
          self.homeModules.default
          # Common
          {
            ${self.lib.namespace}.profiles.minimal.enable = true;
          }
          # Current
          module
        ];
        extraSpecialArgs = {
          inherit inputs' self';
          extra = {
            inherit userName hostName;
          };
        };
      };
    };
  };
}
