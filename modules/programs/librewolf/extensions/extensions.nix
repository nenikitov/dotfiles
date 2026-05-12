{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {
        lib,
        pkgs,
        ...
      }: let
        inherit (lib) types;
      in
        lib.mkOption {
          description = "List of extensions to install.";
          default = [];
          type = types.listOf (types.submodule {
            options = {
              id = lib.mkOption {
                description = "Overwrite for an addon id. If not specified `package.addonId` is used.";
                default = null;
                type = types.nullOr types.str;
              };
              package = lib.mkOption {
                description = "Package of the extension.";
                type = types.package;
              };
              settings = {
                local = lib.mkOption {
                  description = "Local settings stored in browser.";
                  default = null;
                  type = types.nullOr types.json;
                };
                sync = lib.mkOption {
                  description = "Sync settings stored in a DB.";
                  default = null;
                  type = types.nullOr types.json;
                };
              };
            };
          });
          internal = true;
          visible = false;
        };
      config = {
        configNamespace,
        configModule,
        pkgs,
        lib,
        ...
      }: {
        programs.librewolf.profiles.${configNamespace.programs.librewolf._profileName} = {
          settings = {
            # To auto enable extensions
            # TODO: Figure out how to allow extensions to run in private mode
            "extensions.autoDisableScopes" = 0;
            "extensions.update.autoUpdateDefault" = false;
          };

          extensions = {
            force = true;
            packages =
              configModule
              |> builtins.map (e: e.package);
            settings =
              configModule
              |> builtins.filter (e: e.settings.local != null)
              |> builtins.map (e: {
                name =
                  if e.id != null
                  then e.id
                  else if e.package ? "addonId"
                  then e.package.addonId
                  else throw "Cannot figure out addon id";
                value = {
                  force = true;
                  settings = e.settings.local;
                };
              })
              |> builtins.listToAttrs;
          };
        };

        # TODO: Replace this with a librewolf setting when [this issue](https://github.com/nix-community/home-manager/issues/8094) gets resolved.
        home.file.".librewolf/default/storage-sync-v2.sqlite.dummy" = lib.mkIf configNamespace.programs.librewolf.enable {
          force = true;
          # TODO: Replace this with an actual copy mode when [this issue](https://github.com/nix-community/home-manager/issues/3090) gets resolved.
          onChange =
            #sh
            ''
              cp -f "$(realpath ~/".librewolf/default/storage-sync-v2.sqlite.dummy")" ~/".librewolf/default/storage-sync-v2.sqlite"
              rm ~/".librewolf/default/storage-sync-v2.sqlite.dummy"
              chmod 644 ~/".librewolf/default/storage-sync-v2.sqlite"
            '';
          source = pkgs.stdenvNoCC.mkDerivation {
            name = "storage-sync-v2.sqlite";
            src = ./storage-sync-v2.sqlite;
            dontUnpack = true;
            dontInstall = true;
            nativeBuildInputs = with pkgs; [sqlite];
            buildPhase = let
              extensions =
                configModule
                |> builtins.filter (e: e.settings.sync != null);
              command =
                extensions
                |> builtins.map (e: let
                  id =
                    if e.id != null
                    then e.id
                    else if e.package ? "addonId"
                    then e.package.addonId
                    else throw "Cannot figure out addon id";
                in
                  # sql
                  "('${id}', '${builtins.toJSON e.settings.sync}')")
                |> builtins.concatStringsSep ","
                |> (values:
                  # sql
                  ''
                    insert into storage_sync_data (ext_id, data)
                    values ${values};
                  '')
                |> (
                  insert:
                  # sh
                  ''
                    sqlite3 $out ${lib.escapeShellArg insert}
                  ''
                );
            in
              #sh
              ''
                cp $src $out
                chmod +w $out
                ${
                  if builtins.length extensions != 0
                  then command
                  else ""
                }
              '';
          };
        };
      };
    };
  };
}
