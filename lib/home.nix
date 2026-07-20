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
      homeConfigurations."${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
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
