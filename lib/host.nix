{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.lib.host = {
    mkHome = args: {
      userName,
      hostName,
    }: module: let
      # HACK: https://flake.parts/module-arguments.html#how-module-function-arguments-work
      inherit (args.config.allModuleArgs) pkgs inputs' self';
    in {
      "${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # Community
          inputs.niri.homeModules.niri
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

    mkSystem = {hostName}: module: {
      ${hostName} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          # Community
          # Personal
          inputs.generation-trimmer.nixosModules.default
          # Local
          self.nixosModules.default
          # Common
          {
            ${self.lib.namespace}.profiles.minimal.enable = true;
          }
          ({config, ...}: {
            # Inject `inputs'` and `self'` into `specialArgs`
            _module.args = withSystem config.nixpkgs.hostPlatform.system ({
              inputs',
              self',
              ...
            }: {
              inherit inputs' self';
            });
          })
          # Current
          module
        ];
        specialArgs = {
          extra = {
            inherit hostName;
          };
        };
      };
    };
  };
}
