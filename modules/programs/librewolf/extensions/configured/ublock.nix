{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "uBlock origin Librewolf extension";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.ublock-origin;
            settings.local = {
              selectedFilterLists = [
                # Built-in
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                # Ads
                "easylist"
                "adguard-generic"
                "adguard-mobile"
                # Privacy
                "easyprivacy"
                "LegitimateURLShortener"
                "adguard-spyware-url"
                # Malware protection security
                "urlhaus-1"
                "curben-phishing"
                # Multipurpose
                "plowe-0"
                # Cookie notices
                "fanboy-cookiemonster"
                "ublock-cookies-easylist"
                "adguard-cookies"
                "ublock-cookies-adguard"
                "fanboy-social"
                "adguard-social"
                "fanboy-thirdparty_social"
                # Social widgets
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                # Annoyances
                "easylist-annoyances"
                "adguard-mobile-app-banners"
                "adguard-other-annoyances"
                "adguard-popup-overlays"
                "adguard-widgets"
                "ublock-annoyances"
                # Regions languages
                "FRA-0"
                "RUS-0"
                "RUS-1"
              ];
            };
          }
        ];
      };
    };
  };
}
