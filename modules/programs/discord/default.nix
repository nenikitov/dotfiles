{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "discord"];
  description = "Discord chat application";
  config = {
    home.packages = with pkgs; [discord];

    xdg.configFile."discord/settings.json".text = builtins.toJSON {
      SKIP_HOST_UPDATE = true;
      MIN_WIDTH = 0;
      MIN_HEIGHT = 0;
      enableHardwareAcceleration = true;
    };
  };
}
