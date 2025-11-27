pkgs: let
  lib = pkgs.lib;
  buildSwwwPackage = path:
    pkgs.writeShellApplication {
      name = lib.pipe path [
        builtins.baseNameOf
        (lib.removeSuffix ".sh")
      ];
      text = builtins.readFile path;
      runtimeInputs = with pkgs; [
        swww
        imagemagick
      ];
    };
in
  pkgs.symlinkJoin {
    name = "awww_scripts";
    paths = [
      (buildSwwwPackage ./src/wallpaper_init.sh)
      (buildSwwwPackage ./src/wallpaper_set.sh)
    ];
  }
