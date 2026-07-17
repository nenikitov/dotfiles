import { writeFileSync } from "node:fs";

import {
  ClientWindow,
  COMPOSITOR,
  WindowBorder,
  type WaylandWindow,
  ManagedWindow,
  read,
  type DisplayConfigDraft,
  createWindowState,
} from "shoji_wm";
import type { ManagedWindowRect } from "shoji_wm/types";
import { WindowManager } from "./window-manager-new";

function notify(value: any) {
  COMPOSITOR.process.spawn({
    command: ["notify-send", JSON.stringify(value, undefined, 2)],
  });
}

COMPOSITOR.env.apply({
  QT_QPA_PLATFORM: "wayland;xcb",
  QT_QPA_PLATFORMTHEME: "qt6ct",
  QT_IM_MODULE: "fcitx",
  XMODIFIERS: "@im=fcitx",
  SDL_IM_MODULE: "fcitx",
  GLFW_IM_MODULE: "ibus",
  ELECTRON_OZONE_PLATFORM_HINT: "wayland",
});
COMPOSITOR.env.publish();

COMPOSITOR.process.once("dunst", {
  command: "dunst",
  runPolicy: "once-per-session",
});

const wm = new WindowManager(COMPOSITOR);

// Launcher
COMPOSITOR.key.bind("terminal", "Super+Return", () => {
  COMPOSITOR.process.spawn({ command: ["alacritty"] });
});
COMPOSITOR.key.bind("launcher", "Super+Shift+Return", () => {
  COMPOSITOR.process.spawn({ command: ["rofi", "-show", "drun"] });
});

COMPOSITOR.key.bind("debug", "Super+D", () => {
  notify("Debug - Writing");

  const value: any = ["OUTPUTS", wm.outputs.items];

  writeFileSync(
    "/home/nenikitov/.config/shojiwm/debug.json",
    JSON.stringify(value, undefined, 2),
  );

  notify(value);

  notify("Debug - Written");
});

COMPOSITOR.pointer.bindWindowMoveModifier("Super");
COMPOSITOR.pointer.bindWindowResizeModifier("Super");

COMPOSITOR.output.configure((context) => {
  const display: DisplayConfigDraft = {};

  display["DP-1"] = {
    mode: "extend",
    resolution: { width: 1920, height: 1080, refreshRate: 144 },
    position: "auto",
  };
  display["HDMI-A-1"] = {
    mode: "extend",
    resolution: { width: 1920, height: 1080, refreshRate: 75 },
    position: "auto",
  };

  return display;
});

COMPOSITOR.input.configure((input, _context) => {
  input.global = {
    touchpad: {
      tapToClick: true,
      naturalScroll: true,
      scrollMethod: "twoFinger",
      disableWhileTyping: true,
      scrollFactor: 0.3,
    },
    pointer: {
      pointerAccel: 0.0,
      accelProfile: "flat",
    },
  };
});

export default COMPOSITOR;
