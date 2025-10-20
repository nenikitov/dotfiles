{
  libModule,
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
  config = {
    programs.firefox.enable = true;

    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        extraPolicies = {
          # HACK: This breaks the entire policy settings section related to search engines
          # which prevents Librewolf from automatically resetting the search engine to DuckDuckGo
          # so we can set it with `profile.<profile>.search.default`.
          SearchEngines.Default = null;
        };
      };
      profiles.default = {
        name = "Default";
        isDefault = true;

        search = {
          force = true;
          default = "google";
          privateDefault = "wikipedia";
        };

        settings = {
          "webgl.disabled" = false;
          "browser.startup.page" = 3;
          "browser.translations.automaticallyPopup" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "media.eme.enabled" = true;
          "general.autoScroll" = true;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.search.suggest.enabled" = true;
          "browser.search.suggest.enabled.private" = true;
          "browser.urlbar.suggest.searches" = true;
          "privacy.trackingprotection.allow_list.baseline.enabled" = true;
          "browser.formfill.enable" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "permissions.default.desktop-notification" = 2;
          "extensions.update.autoUpdateDefault" = false;
          "middlemouse.paste" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "privacy.resistFingerprinting" = false;
        };
      };
    };
  };
}
