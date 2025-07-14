{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "niri"];
  description = "Niri Wayland compositor";
  config = {configGlobal, ...}: {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        input = {
          mouse.accel-profile = "flat";
        };

        outputs = {
          "DP-4" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 143.981;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
          "HDMI-A-2" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 75.001;
            };
          };
        };

        binds = with configGlobal.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+Return".action = spawn "alacritty";

          "Mod+C".action = close-window;
        };
      };
    };
  };
}
