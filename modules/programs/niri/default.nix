{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "niri"];
  description = "Niri Wayland compositor";
  config = {configGlobal, configNamespace, ...}: {
    # TODO: Handle this with a theme outside this config
    home.packages = with pkgs; [bibata-cursors xwayland-satellite];
    programs.niri.settings.cursor.theme = "Bibata-Modern-Classic";

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        hotkey-overlay = {
          skip-at-startup = true;
          hide-not-bound = true;
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

        workspaces = {
          "1".name = "static-1";
          "2".name = "static-2";
          "3".name = "static-3";
          "4".name = "static-4";
          "5".name = "static-5";
        };

        binds =
          let
            explicitRepeat = builtins.mapAttrs (_: bind: { repeat = false; } // bind);
            moveWindow = pkgs.writers.writePython3 "move-window" { doCheck = false; } (builtins.readFile ./move-window.py);
            moveDistance = "50";
          in explicitRepeat {
            # System
            # TODO: "Mod+Q" to lock
            "Mod+Shift+Q".action.quit = [];
            "Mod+Shift+Slash".action.show-hotkey-overlay = [];
            "Mod+Escape".action.toggle-overview = [];
            "Mod+C".action.close-window = [];

            # Spawning
            "Mod+Return" = {
              action.spawn = "alacritty";
              hotkey-overlay.title = "Open Terminal";
            };
            "Mod+Shift+Return" = {
              action.spawn-sh = /* sh */ ''pkill rofi || rofi -show drun'';
              hotkey-overlay.title = "Open/close application launcher";
            };

            # Monitor focus
            "Mod+Y".action.focus-monitor-left = [];
            "Mod+U".action.focus-monitor-down = [];
            "Mod+I".action.focus-monitor-up = [];
            "Mod+O".action.focus-monitor-right = [];

            # Monitor move
            "Mod+Shift+Y".action.move-window-to-monitor-left = [];
            "Mod+Shift+U".action.move-window-to-monitor-down = [];
            "Mod+Shift+I".action.move-window-to-monitor-up = [];
            "Mod+Shift+O".action.move-window-to-monitor-right = [];

            # Workspace focus
            "Mod+Shift+WheelScrollDown".action.focus-workspace-down = [];
            "Mod+Shift+WheelScrollUp".action.focus-workspace-up = [];
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+Tab".action.focus-workspace-previous = [];

            # Workspace move
            "Mod+Shift+1".action.move-window-to-workspace = [1 { focus = false; }];
            "Mod+Shift+2".action.move-window-to-workspace = [2 { focus = false; }];
            "Mod+Shift+3".action.move-window-to-workspace = [3 { focus = false; }];
            "Mod+Shift+4".action.move-window-to-workspace = [4 { focus = false; }];
            "Mod+Shift+5".action.move-window-to-workspace = [5 { focus = false; }];

            # Window focus
            "Mod+WheelScrollDown".action.focus-column-right = [];
            "Mod+WheelScrollUp".action.focus-column-left = [];
            "Mod+H".action.focus-column-left = [];
            "Mod+J".action.focus-window-down = [];
            "Mod+K".action.focus-window-up = [];
            "Mod+L".action.focus-column-right = [];

            # Window move
            "Mod+Shift+H" = {
              action.spawn = ["${moveWindow}" "--command" "move-column-left" "--x" "-${moveDistance}"];
              hotkey-overlay.title = "Move Column / Floating Window Left";
            };
            "Mod+Shift+J" = {
              action.spawn = ["${moveWindow}" "--command" "move-window-down" "--y" "+${moveDistance}"];
              hotkey-overlay.title = "Move Window Up";
            };
            "Mod+Shift+K" = {
              action.spawn = ["${moveWindow}" "--command" "move-window-up" "--y" "-${moveDistance}"];
              hotkey-overlay.title = "Move Window Down";
            };
            "Mod+Shift+L" = {
              action.spawn = ["${moveWindow}" "--command" "move-column-right" "--x" "+${moveDistance}"];
              hotkey-overlay.title = "Move Column / Floating Window Right";
            };
            "Mod+Shift+Comma".action.consume-or-expel-window-left = [];
            "Mod+Shift+Period".action.consume-or-expel-window-right = [];

            # Window resize
            "Mod+F".action.maximize-column = [];
            "Mod+Shift+F".action.fullscreen-window = [];
            "Mod+R".action.switch-preset-column-width = [];
            "Mod+Shift+R".action.expand-column-to-available-width = [];
            "Mod+Control+H".action.set-window-width = "-10%";
            "Mod+Control+J".action.set-window-height = "+10%";
            "Mod+Control+K".action.set-window-height = "-10%";
            "Mod+Control+L".action.set-window-width = "+10%";

            # Floating
            "Mod+M".action.switch-focus-between-floating-and-tiling = [];
            "Mod+Shift+M".action.toggle-window-floating = [];
        };

        gestures = {
          hot-corners.enable = false;
        };
      };
    };
  };
}
