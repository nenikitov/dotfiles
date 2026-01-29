pkgs: let
  lib = pkgs.lib;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "ne-shell";
    version = "0.1.0";

    src = ./.;

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook4
      gobject-introspection
      ags
    ];

    buildInputs = with pkgs; [
      glib
      gjs
      astal.io
      astal.astal4
    ];

    buildPhase =
      # sh
      ''
        mkdir ./build
        ags bundle app.tsx ./build/${pname}
      '';

    installPhase =
      # sh
      ''
        mkdir -p $out/bin
        cp ./build/${pname} $out/bin
      '';

    #preFixup =
    #  #sh
    #  ''
    #    gappsWrapperArgs+=(
    #      --prefix PATH : ${lib.makeBinPath [
    #      # runtime executables
    #    ]}
    #    )
    #  '';
  }
