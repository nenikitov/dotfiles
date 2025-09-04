{libModule, pkgs, ...}:
libModule.mkEnableModule {
  path = ["programs" "cliphist"];
  description = "cliphist clipboard utility";
  config = {
    home.packages = with pkgs; [
      cliphist
    ];
  };
}
