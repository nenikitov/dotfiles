{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "awww"];
  description = "awww wallpaper utility as well as related helper scripts";
  config = {
    home.packages = [
      (import ./scripts pkgs)
    ];
  };
}
