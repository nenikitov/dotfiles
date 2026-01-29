{
  inputs,
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "ags"];
  description = "custom shell written with AGS toolkit";
  config = {
    home.packages = [
      (import
        ./config
        (pkgs.extend (f: p: {
          astal = inputs.astal.packages.${pkgs.stdenv.hostPlatform.system};
          ags = inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default;
        })))
    ];
  };
}
