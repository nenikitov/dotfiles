{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "ags"];
  description = "custom shell written with AGS toolkit";
  config = {
    home.packages = [
      (import ./config pkgs)
    ];
  };
}
