import {
  ClientWindow,
  COMPOSITOR,
  computed,
  createWindowState,
  cubicBezier,
  ManagedWindow,
  seconds,
  WindowBorder,
  type DisplayConfigDraft,
  type OutputInfo,
  type WaylandWindow,
  type WindowPosition,
} from "shoji_wm";
import { FocusList } from "./util/focus-list";

const list = new FocusList<number>();
list.activeObject!.activate()

export function notify(value: any) {
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

COMPOSITOR.cursor.configure({
  theme: "Adwaita",
  size: 24,
});

COMPOSITOR.output.configure((context) => {
  const display: DisplayConfigDraft = {};

  display["DP-1"] = {
    mode: "extend",
    resolution: "best",
    position: "auto",
    scale: 1.0,
  };
  display["HDMI-A-1"] = {
    mode: "extend",
    resolution: "best",
    position: "auto",
    scale: 1.0,
  };

  return display;
});

COMPOSITOR.input.configure((input, context) => {
  input.global = {
    pointer: {
      accelProfile: "flat",
      pointerAccel: 0,
    },
  };
});

const MOD = "Super";

COMPOSITOR.pointer.bindWindowMoveModifier(`${MOD}`);
COMPOSITOR.pointer.bindWindowResizeModifier(`${MOD}`);

COMPOSITOR.key.bind("terminal", `${MOD}+Return`, () => {
  COMPOSITOR.process.spawn({
    command: ["alacritty"],
  });
});
COMPOSITOR.key.bind("launcher", `${MOD}+Shift+Return`, () => {
  COMPOSITOR.process.spawn({
    command: ["rofi", "-show", "drun"],
  });
});

const states = {
  rect: createWindowState<WindowPosition>("rect", {
    default: () => ({ x: 0, y: 0, width: 0, height: 0 }),
  }),
} as const;

const strut = 8;
const gap = 8;
const openPercent = 0.9;

class Output {
  handle: OutputInfo;
  windows: WaylandWindow[];

  constructor(handle: OutputInfo) {
    this.handle = handle;
    this.windows = [];
  }

  get rect(): WindowPosition | undefined {
    if (this.handle.resolution === undefined) {
      return undefined;
    }

    return {
      x: this.handle.position.x,
      y: this.handle.position.y,
      width: this.handle.resolution.width / this.handle.scale,
      height: this.handle.resolution.height / this.handle.scale,
    };
  }

  addWindow(window: WaylandWindow) {
    const exists = this.windows.some((inWindows) => inWindows.id === window.id);
    if (exists) {
      return;
    }

    this.windows.push(window);
    this.updateLayout();
  }

  removeWindow(window: WaylandWindow): boolean {
    const index = this.windows.findIndex(
      (inWindows) => inWindows.id === window.id,
    );
    if (index < 0) {
      return false;
    }

    this.windows.splice(index, 1);
    this.updateLayout();

    return true;
  }

  updateLayout() {
    const rect = this.rect;

    if (this.windows.length === 0 || rect === undefined) {
      return;
    }

    const easing = cubicBezier(0.1, 0.9, 0.2, 1);
    const duration = seconds(0.25);

    const tile = {
      x: rect.x + strut,
      y: rect.y + strut,
      width:
        (rect.width - 2 * strut - (this.windows.length - 1) * gap) /
        this.windows.length,
      height: rect.height - 2 * strut,
    };

    for (const window of this.windows) {
      let from: WindowPosition = window.state[states.rect].peek();
      if (
        from.x === 0 &&
        from.y === 0 &&
        from.width === 0 &&
        from.height === 0
      ) {
        from = {
          x: tile.x + tile.width * (1 - openPercent),
          y: tile.y + tile.height * (1 - openPercent),
          width: tile.width * (-1 + 2 * openPercent),
          height: tile.height * (-1 + 2 * openPercent),
        };
      }
      const to = { ...tile };

      window.state[states.rect].set(to);
      window.scheduleAnimation({
        channel: "reflow",
        rect: {
          from,
          to,
          easing,
          duration,
        },
      });
      tile.x += tile.width + gap;
    }
  }
}

const outputs: Output[] = [];
let activeOutput: number | null = null;

function updateOutputs(
  added: OutputInfo[],
  changed: OutputInfo[] = [],
  removed: OutputInfo[] = [],
) {
  for (const a of added) {
    const output = new Output(a);
    outputs.push(output);
    if (activeOutput === null) {
      activeOutput = 0;
    }
  }

  for (const c of changed) {
    const output = outputs.find((o) => o.handle.name === c.name);
    if (output === undefined) {
      continue;
    }

    output.handle = c;
    output.updateLayout();
  }

  for (const r of removed) {
    const index = outputs.findIndex((o) => o.handle.name === r.name);
    if (index < 0) {
      continue;
    }

    for (const window of outputs[index].windows) {
      window.close();
    }
    outputs.splice(index, 1);

    if (outputs.length === 0) {
      activeOutput = null;
    } else if (activeOutput !== null) {
      activeOutput = Math.min(activeOutput, outputs.length - 1);
    }
  }
}

COMPOSITOR.event.onPointerMove((event) => {
  const index = outputs.findIndex((o) => o.handle.name === event.outputName);
  if (index < 0) {
    return;
  }

  activeOutput = index;
});

COMPOSITOR.event.onPointerMove((event) => {
  if (event.target.kind !== "window") {
    return;
  }
  const output = outputs.find((o) => o.handle.name === event.outputName);
  if (output === undefined) {
    return;
  }

  const windowId = event.target.windowId;
  const window = output.windows.find((w) => w.id === windowId);
  if (window === undefined) {
    return;
  }

  window.focus()
});

updateOutputs(COMPOSITOR.output.outputs);
COMPOSITOR.event.onOutputChange((event) => {
  updateOutputs(event.added, event.changed, event.removed);
});

COMPOSITOR.event.onFirstCommit((window) => {
  if (window.id === "__warmup__") {
    return;
  }

  if (activeOutput !== null) {
    outputs[activeOutput].addWindow(window);
  }
});

COMPOSITOR.event.onStartClose((window) => {
  for (const output of outputs) {
    if (output.removeWindow(window)) {
      return;
    }
  }
});

COMPOSITOR.event.onWindowResize(() => {});
COMPOSITOR.event.onWindowMove(() => {});

COMPOSITOR.window.composition = (window) => {
  const forceRectSize = computed(() => {
    return window.isResizable() && !window.isTransient();
  });
  const borderColor = window.isFocused((focused) =>
    focused ? "#ff0000" : "#000000",
  );

  return (
    <ManagedWindow
      rect={window.state[states.rect]}
      forceRectSize={forceRectSize}
    >
      <WindowBorder style={{ border: { px: 2, color: borderColor } }}>
        <ClientWindow />
      </WindowBorder>
    </ManagedWindow>
  );
};

COMPOSITOR.key.bind("debug", `${MOD}+D`, () => {
  notify(["ACTIVE OUTPUT", activeOutput]);
});

export default COMPOSITOR;
