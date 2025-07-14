{
  lib,
  libModule,
  options,
  pkgs,
  ...
}:
# {
#   imports = [ ./search-engines.nix ];
# }
# //
libModule.mkEnableModule {
  path = ["programs" "librewolf"];
  description = "Librewolf (Firefox fork) web-browser";
  config = {configModule, ...}: {
    programs.firefox.enable = true;

    programs.librewolf = {
      enable = true;
      profiles.default = {
        isDefault = true;
        search = {
          force = true;
          default = "google";
        };
        settings = {
          "webgl.disabled" = false;
        };
      };
    };
  };
}
