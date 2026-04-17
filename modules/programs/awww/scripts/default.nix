pkgs: let
  lib = pkgs.lib;
  buildAwwwPackage = path:
    pkgs.writeShellApplication {
      name = lib.pipe path [
        builtins.baseNameOf
        (lib.removeSuffix ".sh")
      ];
      text = builtins.readFile path;
      runtimeInputs = with pkgs; [
        awww
        imagemagick
      ];
    };
in
  pkgs.symlinkJoin {
    name = "awww_scripts";
    paths = [
      (buildAwwwPackage ./src/wallpaper_init.sh)
      (buildAwwwPackage ./src/wallpaper_set.sh)
    ];
  }
