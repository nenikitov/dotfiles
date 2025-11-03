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
        id = "addon@darkreader.org";
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
        id = "{cb31ec5d-c49a-4e5a-b240-16c767444f62}";
        settingsSync = {
          hideReviewReminder = true;
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
            name = e.id;
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
    home.file.".librewolf/default/storage-sync-v2.sqlite.home-manager" = {
      force = true;
      # TODO: Replace this with an actual copy mode when [this issue](https://github.com/nix-community/home-manager/issues/3090) gets resolved.
      onChange =
        #sh
        ''
          \cp -f "~/.librewolf/default/storage-sync-v2.sqlite.home-manager" "~/.librewolf/default/storage-sync-v2.sqlite"
          \rm "~/.librewolf/default/storage-sync-v2.sqlite.home-manager"
          chmod 644 "~/.librewolf/default/storage-sync-v2.sqlite"
          echo "Repalced Librewolf config"
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
              "('${e.id}', '${builtins.toJSON e.settingsSync}')"))
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
