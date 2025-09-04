{libModule, pkgs, ...}:
libModule.mkEnableModule {
  path = ["programs" "wl-clipboard"];
  description = "wl-clipboard clipboard utility";
  config = {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
