{libModule, pkgs, ...}:
libModule.mkEnableModule {
  path = ["programs" "brightnessctl"];
  description = "brightnessctl brightness utility";
  config = {
    home.packages = with pkgs; [
      brightnessctl
    ];
  };
}
