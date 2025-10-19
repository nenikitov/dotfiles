{libModule, pkgs, ...}:
# {
#   imports = [ ./search-engines.nix ];
# }
# //
libModule.mkEnableModule {
  path = ["programs" "librewolf"];
  description = "Librewolf (Firefox fork) web-browser";
  config = {
    programs.firefox.enable = true;

    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        extraPolicies = {
          # HACK: This breaks force loading of search engines from policies,
          # which allows setting the default search engine with `profile.<profile>.search.default`.
          SearchEngines.Default = null;
        };
      };
      profiles.default = {
        name = "Default";
        isDefault = true;

        search = {
          force = true;
          default = "wikipedia";
        };

        settings = {
          "webgl.disabled" = false;
        };
      };
    };
  };
}
