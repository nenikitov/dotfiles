{lib, ...}: {
  name = "uBlock0@raymondhill.net";
  storeId = "ublock-origin";

  settings.adminSettings = let
    imported = [
      "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
    ];
  in {
    userSettings = {
      externalLists = lib.concatStringsSep "\n" imported;
    };
    selectedFilterLists =
      [
        # Built-in
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        # Ads
        "easylist"
        "adguard-generic"
        # Privacy
        "easyprivacy"
        "adguard-spyware"
        "adguard-spyware-url"
        # Malware protection, security
        "urlhaus-1"
        # Multipurpose
        "plowe-0"
        # Cookie notices
        "fanboy-cookiemonster"
        "ublock-cookies-easylist"
        "adguard-cookies"
        # Social widgets
        "fanboy-social"
        "adguard-social"
        # Annoyances
        "easylist-chat"
        "easylist-newsletters"
        "easylist-notifications"
        "easylist-annoyances"
        "adguard-mobile-app-banners"
        "adguard-other-annoyances"
        "adguard-popup-overlays"
        "adguard-widgets"
        "ublock-annoyances"
        # Regions, languages
        "FRA-0"
        "RUS-0"
      ]
      ++ imported;
  };
}
