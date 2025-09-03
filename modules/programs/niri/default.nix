{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "niri"];
  description = "Niri Wayland compositor";
  config = {configGlobal, configNamespace, ...}: {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        hotkey-overlay = {
          skip-at-startup = true;
          # hide-not-bound = true;
        };

        input = {
          mouse.accel-profile = "flat";
          keyboard.numlock = true;
          warp-mouse-to-focus = {
            enable = true;
            mode = "center-xy";
          };
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };
        };

        prefer-no-csd = true;

        outputs = configNamespace.settings.monitors;

        layout = {
          gaps = 8;
          default-column-width = { proportion = 1.0 / 2.0; };
          border = {
            enable = true;
            width = 2;
            active.gradient = {
              from = "#DA5261";
              to = "#DB8878";
            };
            inactive.gradient = {
              from = "#555A66";
              to = "#20232B";
            };
          };
          focus-ring.enable = false;
          shadow = {
            enable = true;
            softness = 10;
            offset = {
              x = 0;
              y = 0;
            };
          };
        };

        window-rules = [
          {
            draw-border-with-background = true;
            geometry-corner-radius = let r = 4.0; in {
              bottom-left = r;
              bottom-right = r;
              top-left = r;
              top-right = r;
            };
            clip-to-geometry = true;
          }
        ];

        binds = with configGlobal.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+Return" = {
            action = spawn "alacritty";
            repeat = false;
          };
          "Mod+Space" = {
            action = spawn "rofi" "-show" "drun";
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

        gestures = {
          hot-corners.enable = false;
        };
      };
    };
  };
}
