{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "ShojiWM Wayland compositor";
      config = {inputs', pkgs, ...}: {
        programs.shojiwm = {
          enable = true;
          # HACK: I'm getting hash mismatches without this override
          package = inputs'.shojiwm.packages.default.overrideAttrs (packagePrev: {
            cargoDeps = pkgs.rustPlatform.importCargoLock {
              lockFile = "${packagePrev.src}/Cargo.lock";
              allowBuiltinFetchGit = true;
            };
          });
        };
      };
    };
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "ShojiWM Wayland compositor";
      config = {};
    };
  };
}
