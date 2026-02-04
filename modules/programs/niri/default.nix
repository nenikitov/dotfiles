{
  lib,
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "niri"];
  description = "Niri Wayland compositor";
  config = {
    configNamespace,
    namespace,
    ...
  }: {
    # TODO: Handle this with a theme outside this config
    home.packages = with pkgs; [xwayland-satellite];

    # TODO: Figure out module dependencies specification
    ${namespace} = {
      programs = {
        awww.enable = true;
        quickshell.enable = true;
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = let
        scripts = import ./scripts pkgs;
        pad = {
          len,
          char ? " ",
          left ? true,
        }: str: let
          paddingLength = lib.max 0 (len - builtins.stringLength str);
          padding = lib.concatStrings (lib.genList (_: char) paddingLength);
        in
          if left
          then "${padding}${str}"
          else "${str}${padding}";
        listToIndexedAttrs = {padKeys ? false}: list: let
          len = lib.pipe list [builtins.length builtins.toString builtins.stringLength];
          key = i:
            if padKeys
            then
              pad {
                inherit len;
                char = "0";
              } (builtins.toString i)
            else builtins.toString i;
        in
          builtins.listToAttrs (lib.imap0 (i: value: {
              name = key i;
              inherit value;
            })
            list);
      in {
        spawn-at-startup = [
          {argv = ["${scripts}/bin/keep_static_workspaces" "5"];}
          {argv = ["quickshell"];}
        ];

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

        outputs = lib.pipe configNamespace.settings.monitors [
          (builtins.map (o: (builtins.removeAttrs o ["primary"]) // {focus-at-startup = o.primary;}))
          (listToIndexedAttrs {padKeys = true;})
        ];

        layout = {
          background-color = "transparent";

          default-column-width = {proportion = 1.0 / 2.0;};
          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0 / 1.0;}
          ];

          tab-indicator = {
            position = "top";
            place-within-column = true;
            gaps-between-tabs = 8;
          };

          gaps = 8;

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
            geometry-corner-radius = let
              r = 4.0;
            in {
              bottom-left = r;
              bottom-right = r;
              top-left = r;
              top-right = r;
            };
            clip-to-geometry = true;
          }
        ];

        layer-rules = [
          {
            matches = [{namespace = "swww-daemonoverview";}];
            place-within-backdrop = true;
          }
        ];

        binds = let
          explicitRepeat = builtins.mapAttrs (_: bind: {repeat = false;} // bind);
          moveFactor = "10%";
          resizeFactor = "10%";
        in
          explicitRepeat {
            # System
            # TODO: "Mod+Q" to lock
            "Mod+Shift+Q".action.quit = [];
            "Mod+Shift+Slash".action.show-hotkey-overlay = [];
            "Mod+Escape".action.toggle-overview = [];
            "Mod+C".action.close-window = [];

            # Spawning
            "Mod+Return" = {
              hotkey-overlay.title = "Open Terminal";
              action.spawn = "alacritty";
            };
            "Mod+Shift+Return" = {
              hotkey-overlay.title = "Open/close application launcher";
              action.spawn-sh =
                # sh
                ''pkill rofi || rofi -show drun'';
            };

            # Monitor focus
            "Mod+Y" = {
              action.focus-monitor-left = [];
              repeat = true;
            };
            "Mod+U" = {
              action.focus-monitor-down = [];
              repeat = true;
            };
            "Mod+I" = {
              action.focus-monitor-up = [];
              repeat = true;
            };
            "Mod+O" = {
              action.focus-monitor-right = [];
              repeat = true;
            };

            # Monitor move
            "Mod+Shift+Y" = {
              action.move-window-to-monitor-left = [];
              repeat = true;
            };
            "Mod+Shift+U" = {
              action.move-window-to-monitor-down = [];
              repeat = true;
            };
            "Mod+Shift+I" = {
              action.move-window-to-monitor-up = [];
              repeat = true;
            };
            "Mod+Shift+O" = {
              action.move-window-to-monitor-right = [];
              repeat = true;
            };

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
            "Mod+Shift+1" = {
              action.move-window-to-workspace = [1 {focus = false;}];
            };
            "Mod+Shift+2" = {
              action.move-window-to-workspace = [2 {focus = false;}];
            };
            "Mod+Shift+3" = {
              action.move-window-to-workspace = [3 {focus = false;}];
            };
            "Mod+Shift+4" = {
              action.move-window-to-workspace = [4 {focus = false;}];
            };
            "Mod+Shift+5" = {
              action.move-window-to-workspace = [5 {focus = false;}];
            };

            # Window focus
            "Mod+WheelScrollDown".action.focus-column-right = [];
            "Mod+WheelScrollUp".action.focus-column-left = [];
            "Mod+H" = {
              action.focus-column-left = [];
              repeat = true;
            };
            "Mod+J" = {
              action.focus-window-down = [];
              repeat = true;
            };
            "Mod+K" = {
              action.focus-window-up = [];
              repeat = true;
            };
            "Mod+L" = {
              action.focus-column-right = [];
              repeat = true;
            };

            # Window move
            "Mod+Shift+H" = {
              hotkey-overlay.title = "Move Column / Floating Window Left";
              action.spawn = ["${scripts}/bin/move_window" "--x" "-${moveFactor}" "move-column-left"];
              repeat = true;
            };
            "Mod+Shift+J" = {
              hotkey-overlay.title = "Move Window Up";
              action.spawn = ["${scripts}/bin/move_window" "--y" "+${moveFactor}" "move-window-down"];
              repeat = true;
            };
            "Mod+Shift+K" = {
              hotkey-overlay.title = "Move Window Down";
              action.spawn = ["${scripts}/bin/move_window" "--y" "-${moveFactor}" "move-window-up"];
              repeat = true;
            };
            "Mod+Shift+L" = {
              hotkey-overlay.title = "Move Column / Floating Window Right";
              action.spawn = ["${scripts}/bin/move_window" "--x" "+${moveFactor}" "move-column-right"];
              repeat = true;
            };
            "Mod+Shift+Comma".action.consume-or-expel-window-left = [];
            "Mod+Shift+Period".action.consume-or-expel-window-right = [];

            # Window resize
            "Mod+F".action.maximize-column = [];
            "Mod+Shift+F".action.fullscreen-window = [];
            "Mod+R".action.switch-preset-column-width = [];
            "Mod+Shift+R".action.expand-column-to-available-width = [];
            "Mod+Control+H" = {
              action.set-window-width = "-${resizeFactor}";
              repeat = true;
            };
            "Mod+Control+J" = {
              action.set-window-height = "+${resizeFactor}";
              repeat = true;
            };
            "Mod+Control+K" = {
              action.set-window-height = "-${resizeFactor}";
              repeat = true;
            };
            "Mod+Control+L" = {
              action.set-window-width = "+${resizeFactor}";
              repeat = true;
            };

            # Floating/tabbing
            "Mod+M".action.switch-focus-between-floating-and-tiling = [];
            "Mod+Shift+M".action.toggle-window-floating = [];
            "Mod+T".action.toggle-column-tabbed-display = [];
          };

        gestures = {
          hot-corners.enable = false;
        };
      };
    };
  };
}
