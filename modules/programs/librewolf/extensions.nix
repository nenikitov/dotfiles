{
  inputs,
  lib,
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableSubmodule {
  pathParent = ["programs" "librewolf"];
  config = let
    pkgsFirefoxAddons = inputs.firefoxAddons.packages.${pkgs.system};
    extensions = [
      # Dark Reader
      {
        package = pkgsFirefoxAddons.darkreader;
        settingsSync = {
          fetchNews = false;
          automation = {
            enabled = true;
            mode = "system";
          };
        };
      }
      # Indie Wiki Buddy
      {
        package = pkgsFirefoxAddons.indie-wiki-buddy;
        settingsSync = {
          notifications = false;
          breezewiki = "redirect";
        };
      }
      # Return YouTube Dislikes
      {
        package = pkgsFirefoxAddons.return-youtube-dislikes;
      }
      # Search by Image
      {
        package = pkgsFirefoxAddons.search-by-image;
      }
      # SponsorBlock
      {
        package = pkgsFirefoxAddons.sponsorblock;
        settingsSync = {
          categorySelections = [
            {
              name = "filler";
              option = 1;
            }
            {
              name = "hook";
              option = 1;
            }
            {
              name = "interaction";
              option = 1;
            }
            {
              name = "intro";
              option = 1;
            }
            {
              name = "music_offtopic";
              option = 1;
            }
            {
              name = "poi_highlight";
              option = 1;
            }
            {
              name = "preview";
              option = 1;
            }
            {
              name = "selfpromo";
              option = 1;
            }
            {
              name = "sponsor";
              option = 1;
            }
            {
              name = "chapter";
              option = 0;
            }
            {
              name = "exclusive_access";
              option = 0;
            }
          ];
          showDeArrowInSettings = false;
          showDeArrowPromotion = false;
          hideVideoPlayerControls = true;
        };
      }
      # uBlock Origin
      {
        package = pkgsFirefoxAddons.ublock-origin;
        settings = {
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
  in {
    programs.librewolf.profiles.default = {
      extensions = {
        force = true;
        packages = lib.pipe extensions [(builtins.map (e: e.package))];
        settings = lib.pipe extensions [
          (builtins.filter (builtins.hasAttr "settings"))
          (builtins.map (e: {
            name = e.package.addonId;
            value = {
              force = true;
              settings = e.settings;
            };
          }))
          builtins.listToAttrs
        ];
      };
      settings = {
        # To auto enable extensions
        # TODO: Figure out how to allow extensions to run in private mode
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
      };
    };
    # TODO: Replace this with a librewolf setting when [this issue](https://github.com/nix-community/home-manager/issues/8094) gets resolved.
    home.file.".librewolf/default/storage-sync-v2.sqlite.dummy" = {
      force = true;
      # TODO: Replace this with an actual copy mode when [this issue](https://github.com/nix-community/home-manager/issues/3090) gets resolved.
      onChange =
        #sh
        ''
          \cp -f "$(realpath ~/".librewolf/default/storage-sync-v2.sqlite.dummy")" ~/".librewolf/default/storage-sync-v2.sqlite"
          \rm ~/".librewolf/default/storage-sync-v2.sqlite.dummy"
          chmod 644 ~/".librewolf/default/storage-sync-v2.sqlite"
        '';
      source = pkgs.stdenvNoCC.mkDerivation {
        name = "storage-sync-v2.sqlite";
        src = ./storage-sync-v2.sqlite;
        dontUnpack = true;
        dontInstall = true;
        nativeBuildInputs = with pkgs; [sqlite];
        buildPhase = let
          values = lib.pipe extensions [
            (builtins.filter (builtins.hasAttr "settingsSync"))
            (builtins.map (e:
              #sql
              "('${e.package.addonId}', '${builtins.toJSON e.settingsSync}')"))
            (builtins.concatStringsSep ",")
          ];
          insert =
            #sql
            ''
              insert into storage_sync_data (ext_id, data)
              values ${values};
            '';
        in
          #sh
          ''
            cp $src $out
            chmod +w $out
            sqlite3 $out ${lib.escapeShellArg insert}
          '';
      };
    };
  };
}
