{
  libModule,
  pkgs,
  ...
}:
{imports = [./extensions.nix ./search-engines.nix];}
// libModule.mkEnableModule {
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
          default = "brave";
        };

        settings = {
          "findbar.highlightAll" = true;
          "accessibility.typeaheadfind.flashBar" = 0;
          "svg.context-properties.content.enabled" = true;
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
          "privacy.trackingprotection.allow_list.baseline.enabled" = false;
          "browser.formfill.enable" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "permissions.default.desktop-notification" = 2;
          "permissions.default.shortcuts" = 2;
          "middlemouse.paste" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "privacy.resistFingerprinting" = false;
          "browser.tabs.inTitlebar" = 0;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.uidensity" = 1;
          "browser.compactmode.show" = true;
          "browser.urlbar.shortcuts.actions" = false;
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              unified-extensions-area = [
                "sponsorblocker_ajay_app-browser-action"
                "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
                "_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action"
                "_cb31ec5d-c49a-4e5a-b240-16c767444f62_-browser-action"
              ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "vertical-spacer"
                "customizableui-special-spring1"
                "urlbar-container"
                "customizableui-special-spring2"
                "ublock0_raymondhill_net-browser-action"
                "addon_darkreader_org-browser-action"
                "unified-extensions-button"
                "downloads-button"
                "fxa-toolbar-menu-button"
                "reset-pbm-toolbar-button"
              ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
              ];
            };
            currentVersion = 23;
          };
        };
      };
    };
  };
}
