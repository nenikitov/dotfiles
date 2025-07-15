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

        layout.preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0 ; }
        ];

        binds = with configGlobal.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+Return" = {
            action = spawn "alacritty";
            repeat = false;
          };

          "Mod+K".action = focus-window-up;
          "Mod+J".action = focus-window-down;
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;

          "Mod+Shift+K".action = move-window-up;
          "Mod+Shift+J".action = move-window-down;
          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+L".action = move-column-right;

          "Mod+Shift+Comma".action = consume-or-expel-window-left;
          "Mod+Shift+Period".action = consume-or-expel-window-right;

          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;

          "Mod+F" = {
            action = switch-preset-column-width;
            repeat = false;
          };
          "Mod+Shift+F" = {
            action = fullscreen-window;
            repeat = false;
          };

          "Mod+C" = {
            action = close-window;
            repeat = false;
          };
        };
      };
    };
  };
}
