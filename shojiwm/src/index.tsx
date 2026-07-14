import { writeFileSync } from "node:fs";

import {
  ClientWindow,
  COMPOSITOR,
  WindowBorder,
  type WaylandWindow,
  computed,
  ManagedWindow,
  read,
  type DisplayConfigDraft,
  createWindowState,
  type Signal,
  type WindowStateKey,
} from "shoji_wm";
import type { ManagedWindowRect } from "shoji_wm/types";

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

// Launcher
COMPOSITOR.key.bind("terminal", "Super+Return", () => {
  COMPOSITOR.process.spawn({ command: ["alacritty"] });
});
COMPOSITOR.key.bind("launcher", "Super+Shift+Return", () => {
  COMPOSITOR.process.spawn({ command: ["rofi", "-show", "drun"] });
});

const windows: WaylandWindow[] = [];
COMPOSITOR.event.onFirstCommit((window) => windows.push(window));
COMPOSITOR.event.onClose((window) => {
  const index = windows.findIndex((w) => w.id === window.id);
  if (index !== -1) {
    windows.splice(index, 1);
  }
});

COMPOSITOR.key.bind("debug", "Super+D", () => {
  notify("Debug - Writing");

  const value: any = [
    "STATES",
    "STATES",
    ...windows.map((w) => read(w.state[state.rect])),
  ];

  writeFileSync(
    "/home/nenikitov/.config/shojiwm/debug.json",
    JSON.stringify(value, undefined, 2),
  );

  notify("Debug - Written");
});

COMPOSITOR.pointer.bindWindowMoveModifier("Super");
COMPOSITOR.pointer.bindWindowResizeModifier("Super");

const state = {
  rect: createWindowState<ManagedWindowRect>("rect", {
    default: (window) => window.position,
  }),
} as const;

const border = 2;

COMPOSITOR.event.onFirstCommit((window) => {
  window.state[state.rect].set({
    x: window.rect.x - border,
    y: window.rect.y - border,
    width: window.rect.width + 2 * border,
    height: window.rect.height + 2 * border,
  } as ManagedWindowRect);
});
COMPOSITOR.event.onWindowResize((event) => {
  event.window.state[state.rect].set(event.currentRect);
  event.window.state;
});
COMPOSITOR.event.onWindowMove((event) => {
  event.window.state[state.rect].set(event.currentRect);
});

COMPOSITOR.window.composition = (window) => {
  return (
    <ManagedWindow rect={window.state[state.rect]()}>
      <WindowBorder
        style={{
          borderRadius: 5,
          border: {
            px: border,
            color: window.isFocused((f) => (f ? "#d7ba7d" : "#4f5666")),
          },
        }}
        interaction={{
          resizeHitArea: {
            cornerPx: 16,
            edgePx: 8,
          },
        }}
      >
        <ClientWindow />
      </WindowBorder>
    </ManagedWindow>
  );
};

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
