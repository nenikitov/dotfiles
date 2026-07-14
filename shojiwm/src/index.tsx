import { writeFileSync } from "node:fs";

import {
  AppIcon,
  Box,
  Button,
  ClientWindow,
  Image,
  ShaderEffect,
  Label,
  COMPOSITOR,
  WindowBorder,
  backdropSource,
  compileEffect,
  compileLayerEffect,
  dualKawaseBlur,
  type SSDStyle,
  type WaylandWindow,
  computed,
  useState,
  shaderStage,
  loadShader,
  layerSource,
  ManagedWindow,
  read,
  type DisplayConfigDraft,
  compilePopupEffect,
  popupSource,
  createWindowState,
  type ReadonlySignal,
} from "shoji_wm";
import type {
  CompositionRenderable,
  ManagedWindowRect,
  MaybeSignal,
} from "shoji_wm/types";
import { createIpcServer } from "shoji_wm/ipc";
import {
  HybridWindowManager,
  TITLEBAR_HEIGHT,
  WINDOW_BORDER_PX,
  WINDOW_STATE_FULLSCREEN,
  WINDOW_STATE_MINIMIZED,
  WINDOW_STATE_MINIMIZE_VISUAL_IDLE,
  WINDOW_STATE_TILE_DRAGGING,
  WINDOW_STATE_TILED,
  WINDOW_STATE_VISIBLE_OUTPUTS,
  WINDOW_STATE_RECT,
  WINDOW_STATE_WORKSPACE_VISIBLE,
  WINDOW_STATE_WORKSPACE_OFFSET_Y,
  WINDOW_STATE_WORKSPACE_OPACITY,
} from "./window-manager";
import { WindowManager } from "./window-manager-new";
import { Match } from "./window-manager-new/match";
import { defaultWindowComposition } from "shoji_wm/default-composition";

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

const workspaceKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

// System control
/*
COMPOSITOR.key.bind("play", "XF86AudioPlay", () => {
  COMPOSITOR.process.spawn({ command: "playerctl play-pause" });
});
COMPOSITOR.key.bind("pause", "XF86AudioPause", () => {
  COMPOSITOR.process.spawn({ command: "playerctl play-pause" });
});
COMPOSITOR.key.bind("next", "XF86AudioNext", () => {
  COMPOSITOR.process.spawn({ command: "playerctl next" });
});
COMPOSITOR.key.bind("prev", "XF86AudioPrev", () => {
  COMPOSITOR.process.spawn({ command: "playerctl previous" });
});
*/

// Launcher
COMPOSITOR.key.bind("terminal", "Super+Return", () => {
  COMPOSITOR.process.spawn({ command: ["alacritty"] });
});
COMPOSITOR.key.bind("launcher", "Super+Shift+Return", () => {
  COMPOSITOR.process.spawn({ command: ["rofi", "-show", "drun"] });
});

// Focus
/*
COMPOSITOR.key.bind("window-focus-left", "Super+H", () => {
  HYBRID_WINDOW_MANAGER.focusTile(-1);
});
COMPOSITOR.key.bind("window-focus-right", "Super+L", () => {
  HYBRID_WINDOW_MANAGER.focusTile(1);
});
for (const [iZero, key] of workspaceKeys.entries()) {
  const iOne = iZero + 1;

  COMPOSITOR.key.bind(`workspace-focus-${iOne}`, `Super+${key}`, () => {
    const monitor = HYBRID_WINDOW_MANAGER.getCurrentMonitorName();
    HYBRID_WINDOW_MANAGER.switchWorkspaceTo(monitor, iOne);
    scheduleWorkspaceBroadcast();
  });
  COMPOSITOR.key.bind(
    `window-move-workspace-${iOne}`,
    `Super+Shift+${key}`,
    () => {
      const workspace = HYBRID_WINDOW_MANAGER.getCurrentWorkspace();
      if (!workspace) return;

      const delta = Math.abs(iOne - workspace.index);
      const dir = Math.sign(iOne - workspace.index) as -1 | 1;

      for (let i = 0; i < delta; i++) {
        HYBRID_WINDOW_MANAGER.moveFocusedWindowToWorkspace(dir);
      }
    },
  );
}

// Movement
COMPOSITOR.key.bind("window-move-left", "Super+Shift+H", () => {
  HYBRID_WINDOW_MANAGER.moveFocusedTile(-1);
  scheduleWorkspaceBroadcast();
});
COMPOSITOR.key.bind("window-move-right", "Super+Shift+L", () => {
  HYBRID_WINDOW_MANAGER.moveFocusedTile(1);
  scheduleWorkspaceBroadcast();
});

// Resize
COMPOSITOR.key.bind("toggle-focused-window-maximize", "Super+F", () => {
  HYBRID_WINDOW_MANAGER.toggleFocusedWindowMaximize();
});

// Interaction
COMPOSITOR.key.bind("close-focused-window", "Super+C", () => {
  HYBRID_WINDOW_MANAGER.closeFocusedWindow();
});

// Other
COMPOSITOR.key.bind("toggle-tiling-mode", "Super+S", () => {
  HYBRID_WINDOW_MANAGER.toggleCurrentWorkspaceTiling();
  scheduleWorkspaceBroadcast();
});
*/

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

COMPOSITOR.event.onFirstCommit((window) => {
  window.state[state.rect].set(window.position);
});
COMPOSITOR.event.onWindowResize((event) => {
  event.window.state[state.rect].set(event.currentRect);
});
COMPOSITOR.event.onWindowMove((event) => {
  event.window.state[state.rect].set(event.currentRect);
});

COMPOSITOR.window.composition = (window) => {
  const border = 2;

  const rect = computed(() => {
    const rect = window.state[state.rect]();
    return {
      x: read(rect.x) - border,
      y: read(rect.y) - border,
      width: read(rect.width) + 2 * border,
      height: read(rect.height) + 2 * border,
    };
  });

  return (
    <ManagedWindow rect={rect}>
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

  // const rect: ManagedWindowRect = {
  //   x: window.position.x - border,
  //   y: window.position.y - border,
  //   width: Math.max(window.position.width, 100) + 2 * border,
  //   height: Math.max(window.position.height, 100) + 2 * border,
  // };
  //
  // return (
  //   <ManagedWindow rect={rect} zIndex={1}>
  //     <WindowBorder
  //       style={{
  //         borderRadius: 5,
  //         border: {
  //           px: border,
  //           color: window.isFocused((f) => (f ? "#d7ba7d" : "#4f5666")),
  //         },
  //       }}
  //       interaction={{
  //         resizeHitArea: {
  //           cornerPx: 16,
  //           edgePx: 8,
  //         },
  //       }}
  //     >
  //       <ClientWindow />
  //     </WindowBorder>
  //   </ManagedWindow>
  // );
};

/*
const wm = new WindowManager(COMPOSITOR);

COMPOSITOR.event.onOpen((window) => {
  window.focus();
});
COMPOSITOR.key.bind("close", "Super+C", () => {
  wm.windowClose(Match.window({ active: Match.eq(true) }));
});

COMPOSITOR.window.composition = (window) => {
  const border = 2;

  const rect: ManagedWindowRect = {
    x: window.position.x - border,
    y: window.position.y - border,
    width: Math.max(window.position.width, 1000) + 2 * border,
    height: Math.max(window.position.height, 1000) + 2 * border,
  };

  return (
    <ManagedWindow rect={rect} zIndex={1}>
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
*/

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

/*
COMPOSITOR.effect.background_effect = compileEffect({
  input: backdropSource(),
  invalidate: { kind: "on-source-damage-box", antiArtifactMargin: 8 },
  pipeline: [dualKawaseBlur({ radius: 4, passes: 2 })],
});

const LAYER_BLUR_MASK = compileLayerEffect({
  input: backdropSource(),
  invalidate: { kind: "on-source-damage-box", antiArtifactMargin: 8 },
  // The mask stage intentionally outputs transparency (the blur is clipped
  // to the layer's own alpha), so the pipeline's alpha must survive the
  // finish/display passes instead of being forced opaque.
  alpha: "preserve",
  pipeline: [
    dualKawaseBlur({ radius: 4, passes: 2 }),
    shaderStage(loadShader("./src/layer-blur-mask.frag"), {
      textures: {
        layer_mask: layerSource(),
      },
      uniforms: {
        opacity_threshold: 0.25,
        mask_feather: 0.04,
      },
    }),
  ],
});

COMPOSITOR.effect.layer = (layer) => {
  if (layer.namespace() === "no_blur") {
    return {};
  }

  return {
    behind: LAYER_BLUR_MASK,
  };
};

const POPUP_BLUR = compilePopupEffect({
  input: backdropSource(),
  invalidate: { kind: "on-source-damage-box", antiArtifactMargin: 8 },
  // The mask stage intentionally outputs transparency (the blur is clipped
  // to the layer's own alpha), so the pipeline's alpha must survive the
  // finish/display passes instead of being forced opaque.
  alpha: "preserve",
  pipeline: [
    dualKawaseBlur({ radius: 4, passes: 2 }),
    shaderStage(loadShader("./src/layer-blur-mask.frag"), {
      textures: {
        layer_mask: popupSource(),
      },
      uniforms: {
        opacity_threshold: 0.25,
        mask_feather: 0.04,
      },
    }),
  ],
});

COMPOSITOR.effect.popup = (popup) => {
  if (popup.parentKind === "window") {
    return {};
  }

  return {
    behind: POPUP_BLUR,
  };
};

COMPOSITOR.event.onOpen((window) => {
  HYBRID_WINDOW_MANAGER.onOpen(window);
});

COMPOSITOR.event.onFirstCommit((window) => {
  HYBRID_WINDOW_MANAGER.onFirstCommit(window);
  scheduleWorkspaceBroadcast();
});

COMPOSITOR.event.onStartClose((window) => {
  HYBRID_WINDOW_MANAGER.onStartClose(window);
  scheduleWorkspaceBroadcast();
});

COMPOSITOR.event.onClose((window) => {
  HYBRID_WINDOW_MANAGER.onClose(window);
  scheduleWorkspaceBroadcast();
});

COMPOSITOR.event.onFocus((window, focused) => {
  HYBRID_WINDOW_MANAGER.onFocus(window, focused);
  if (focused) {
    HYBRID_WINDOW_MANAGER.recordFocus(window.id);
    scheduleWorkspaceBroadcast();
  }
});

COMPOSITOR.event.onPointerMoveAsync((event) => {
  HYBRID_WINDOW_MANAGER.onPointerMove(event);
});

COMPOSITOR.event.onGestureSwipeAsync((event) => {
  HYBRID_WINDOW_MANAGER.onGestureSwipe(event);
  scheduleWorkspaceBroadcast();
});

COMPOSITOR.event.onOutputChange((event) => {
  HYBRID_WINDOW_MANAGER.onOutputChange(event);
  scheduleWorkspaceBroadcast();
});

COMPOSITOR.event.onCreateLayer(() => {
  HYBRID_WINDOW_MANAGER.refreshUsableAreaLayouts();
});

COMPOSITOR.event.onUpdateLayer(() => {
  HYBRID_WINDOW_MANAGER.refreshUsableAreaLayouts();
});

COMPOSITOR.event.onDestroyLayer(() => {
  HYBRID_WINDOW_MANAGER.refreshUsableAreaLayouts();
});

COMPOSITOR.event.onWindowResize((event) => {
  HYBRID_WINDOW_MANAGER.onWindowResize(event);
});

COMPOSITOR.pointer.bindWindowMoveModifier("Super");

COMPOSITOR.event.onWindowMove((event) => {
  HYBRID_WINDOW_MANAGER.onWindowMove(event);
});

COMPOSITOR.event.onWindowMaximizeRequest((event) => {
  HYBRID_WINDOW_MANAGER.onWindowMaximizeRequest(event);
});

COMPOSITOR.event.onWindowMinimizeRequest((event) => {
  HYBRID_WINDOW_MANAGER.onWindowMinimizeRequest(event);
});

COMPOSITOR.event.onWindowFullscreenRequest((event) => {
  HYBRID_WINDOW_MANAGER.onWindowFullscreenRequest(event);
});

COMPOSITOR.event.onWindowActivateRequest((event) => {
  HYBRID_WINDOW_MANAGER.onWindowActivateRequest(event);
  scheduleWorkspaceBroadcast();
});

function naturalRootRect(window: WaylandWindow): ManagedWindowRect {
  const client = window.position;
  return {
    x: client.x - WINDOW_BORDER_PX,
    y: client.y - TITLEBAR_HEIGHT - WINDOW_BORDER_PX,
    width: client.width + WINDOW_BORDER_PX * 2,
    height: client.height + TITLEBAR_HEIGHT + WINDOW_BORDER_PX * 2,
  };
}

COMPOSITOR.window.composition = (window: WaylandWindow) => {
  const workspaceVisible = window.state[WINDOW_STATE_WORKSPACE_VISIBLE];
  const workspaceOffsetY = window.state[WINDOW_STATE_WORKSPACE_OFFSET_Y];
  const workspaceOpacity = window.state[WINDOW_STATE_WORKSPACE_OPACITY];
  const tileDragging = window.state[WINDOW_STATE_TILE_DRAGGING];
  const managedRect = computed(() => {
    const rect = window.state[WINDOW_STATE_RECT]();
    return {
      x: read(rect.x),
      y: read(rect.y) + workspaceOffsetY(),
      width: read(rect.width),
      height: read(rect.height),
    };
  });
  const forceRectSize = computed(
    () => window.isResizable() && !window.isTransient(),
  );
  const tiled = computed(
    () => window.appId() === "mpv" || window.state[WINDOW_STATE_TILED](),
  );
  const minimizeVisualIdle = window.state[WINDOW_STATE_MINIMIZE_VISUAL_IDLE];
  const inactive = computed(
    () => minimizeVisualIdle() || (!workspaceVisible() && !tileDragging()),
  );

  const borderColor = window.isFocused((focused) =>
    focused ? "#d7ba7d" : "#4f5666",
  );
  const titlebarBackground = window.isFocused((focused) =>
    focused ? "#1f243080" : "#2a2f3a80",
  );
  const titleColor = window.isFocused((focused) =>
    focused ? "#f5f7fa" : "#c9d1d9",
  );

  const titlebarStyle: SSDStyle = {
    height: TITLEBAR_HEIGHT,
    paddingX: 8,
    gap: 8,
    alignItems: "center",
    background: titlebarBackground,
  };

  const backgroundShader = compileEffect({
    input: backdropSource(),
    invalidate: { kind: "on-source-damage-box", antiArtifactMargin: 8 },
    pipeline: [
      dualKawaseBlur({ radius: 4, passes: 2 }),
      shaderStage(loadShader("./src/liquid-glass.frag"), {
        uniforms: {
          glass_radius_px: 10.0,
          distortion_depth: 0.2,
          distortion_strength: 0.15,
          chromatic_shift_px: 3.0,
          glass_tint: 0.9,
        },
      }),
    ],
  });

  const titleOnlyShader = compileEffect({
    input: backdropSource(),
    invalidate: { kind: "on-source-damage-box", antiArtifactMargin: 8 },
    pipeline: [dualKawaseBlur({ radius: 4, passes: 2 })],
  });

  const appIcon = (
    <AppIcon icon={window.icon} style={{ width: 16, height: 16 }} />
  );
  const label = (
    <Label
      text={window.title}
      style={{
        color: titleColor,
        fontFamily: ["Noto Sans CJK JP", "Noto Color Emoji"],
        fontSize: 13,
        fontWeight: 600,
        flexGrow: 1,
        flexShrink: 1,
        minWidth: 0,
      }}
    />
  );
  const minimizeButton = <MinimizeButton window={window} />;
  const maximizeButton = <MaximizeButton window={window} />;
  const closeButton = <CloseButton window={window} />;

  var innerComponents = (
    <Box direction="column">
      <ShaderEffect
        shader={titleOnlyShader}
        direction="row"
        style={titlebarStyle}
      >
        {appIcon}
        {label}
        {minimizeButton}
        {maximizeButton}
        {closeButton}
      </ShaderEffect>
      <ClientWindow />
    </Box>
  );

  const TERMINALS = ["kitty", "ghostty"];

  if (TERMINALS.includes(window.appId() ?? "")) {
    innerComponents = (
      <ShaderEffect shader={backgroundShader} direction="column">
        <Box direction="row" style={titlebarStyle}>
          {appIcon}
          {label}
          {minimizeButton}
          {maximizeButton}
          {closeButton}
        </Box>
        <ClientWindow />
      </ShaderEffect>
    );
  }

  // Fullscreen: drop all chrome (titlebar, border, rounded corners) and let
  // the client surface fill its managed rect edge to edge. The rect is set to
  // the whole output by onWindowFullscreenRequest. Rendering nothing but the
  // bare ClientWindow is also what lets the tty backend promote the client
  // buffer to the primary plane (direct scanout).
  if (window.state[WINDOW_STATE_FULLSCREEN]()) {
    return (
      <ManagedWindow
        rect={managedRect}
        zIndex={FULLSCREEN_Z_INDEX}
        visibleOutputs={window.state[WINDOW_STATE_VISIBLE_OUTPUTS]}
        opacity={workspaceOpacity}
        forceRectSize={forceRectSize}
        tiled={tiled}
        idle={inactive}
        interactive={inactive((value) => !value)}
        // Permit low-latency tearing for fullscreen windows. The compositor only actually tears
        // once the window is on the direct-scanout fast path and is committing faster than the
        // refresh rate (i.e. games), so this is a no-op for ordinary fullscreen apps. Narrow it
        // per app if desired, e.g. `allowTearing={isGame(window.appId())}`.
        allowTearing={true}
      >
        <ClientWindow />
      </ManagedWindow>
    );
  }

  return (
    <ManagedWindow
      rect={managedRect}
      zIndex={HYBRID_WINDOW_MANAGER.getWindowZIndex(window)}
      visibleOutputs={window.state[WINDOW_STATE_VISIBLE_OUTPUTS]}
      opacity={workspaceOpacity}
      forceRectSize={forceRectSize}
      tiled={tiled}
      idle={inactive}
      interactive={inactive((value) => !value)}
    >
      <WindowBorder
const states = {
  rectTarget: createWindowState<ManagedWindowRect>("rectTarget", {
    default: (window) => {
      return window.rect;
    },
  }),
} as const;

const border = 2;
function rectWithDecorations(
  rect: MaybeSignal<ManagedWindowRect>,
): ReadonlySignal<ManagedWindowRect> {
  return computed(() => {
    const r = read(rect);
    return {
      x: read(r.x) - border,
      y: read(r.y) - border,
      width: read(r.width) + 2 * border,
      height: read(r.height) + 2 * border,
    };
  });
}

        style={{
          border: { px: WINDOW_BORDER_PX, color: borderColor },
          borderRadius: 10,
          background: "#10131900",
          padding: 0,
          paddingX: 0,
          paddingRight: 0,
        }}
        interaction={{
          resizeHitArea: {
            edgePx: 8,
            cornerPx: 14,
          },
        }}
      >
        <Box direction="row">{innerComponents}</Box>
      </WindowBorder>
    </ManagedWindow>
  );
};

const CloseButton = ({ window }: { window: WaylandWindow }) => {
  const [hover, setHover] = useState(false);

  const borderColor = hover((hover) => (hover ? "#00000000" : "#F0808030"));

  var icon: CompositionRenderable | null = null;
  if (hover()) {
    icon = (
      <Image
        src="./assets/x.svg"
        style={{
          width: 16,
          height: 16,
          position: "absolute",
          zIndex: 1,
          pointerEvents: "none",
        }}
      />
    );
  }

  return (
    <Box style={{ position: "relative", flexShrink: 0 }}>
      <Button
        onHoverChange={setHover}
        style={{
          width: 16,
          height: 16,
          borderRadius: 8,
          background: "#FFFFFF20",
          border: { px: 1, color: borderColor },
        }}
        onClick={window.close}
      />
      {icon}
    </Box>
  );
};

const MaximizeButton = ({ window }: { window: WaylandWindow }) => {
  const [hover, setHover] = useState(false);

  const borderColor = computed(() => {
    if (!window.isResizable()) {
      return "#00000000";
    }
    return hover() ? "#00000000" : "#00BFFF30";
  });
  const shouldHover = computed(() => hover() && window.isResizable());

  var icon: CompositionRenderable | null = null;
  if (shouldHover()) {
    const src = window.isMaximized((maximized) => {
      return maximized ? "./assets/minimize-2.svg" : "./assets/maximize-2.svg";
    });

    icon = (
      <Image
        src={src}
        style={{
          width: 16,
          height: 16,
          position: "absolute",
          zIndex: 1,
          pointerEvents: "none",
        }}
      />
    );
  }

  return (
    <Box style={{ position: "relative", flexShrink: 0 }}>
      <Button
        onHoverChange={setHover}
        style={{
          width: 16,
          height: 16,
          borderRadius: 8,
          background: "#FFFFFF20",
          border: { px: 1, color: borderColor },
        }}
        onClick={() => {
          if (!read(window.isResizable)) {
            return;
          }

          if (read(window.isMaximized)) {
            window.unmaximize();
          } else {
            window.maximize();
          }
        }}
      />
      {icon}
    </Box>
  );
};

const MinimizeButton = ({ window }: { window: WaylandWindow }) => {
  const [hover, setHover] = useState(false);

  const borderColor = hover((hover) => (hover ? "#00000000" : "#F8FF7530"));

  var icon: CompositionRenderable | null = null;
  if (hover()) {
    icon = (
      <Image
        src="./assets/minus.svg"
        style={{
          width: 16,
          height: 16,
          position: "absolute",
          zIndex: 1,
          pointerEvents: "none",
        }}
      />
    );
  }

  return (
    <Box style={{ position: "relative", flexShrink: 0 }}>
      <Button
        onHoverChange={setHover}
        style={{
          width: 16,
          height: 16,
          borderRadius: 8,
          background: "#FFFFFF20",
          border: { px: 1, color: borderColor },
        }}
        onClick={() => window.minimize()}
      />
      {icon}
    </Box>
  );
};
*/

export default COMPOSITOR;
