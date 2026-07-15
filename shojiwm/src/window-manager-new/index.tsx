// The hierarchy is
// - Monitor -> Workspace -> Tile (column for horizontal scrolling, row for vertical) -> Window

import {
  ClientWindow,
  ManagedWindow,
  WindowBorder,
  type CompositorDefinition,
  type OutputInfo,
  type WaylandWindow,
  type WindowCompositionFunction,
} from "shoji_wm";
import { getState, state } from "./state";
import { FocusList } from "../util/focus-list";

// TODO: Should be in the config
const border = 2;

export class WindowManager {
  private readonly windows: WaylandWindow[] = [];

  constructor(private readonly compositor: CompositorDefinition) {
    // Keep track of windows
    this.compositor.event.onFirstCommit((window) => {
      this.windows.push(window);
    });
    this.compositor.event.onClose((window) => {
      const index = this.windows.findIndex((w) => w.id === window.id);
      if (index !== -1) {
        this.windows.splice(index, 1);
      }
    });

    // Register rect
    this.compositor.event.onFirstCommit((window) => {
      getState(window, state.rect).set({
        x: window.rect.x - border,
        y: window.rect.y - border,
        width: window.rect.width + 2 * border,
        height: window.rect.height + 2 * border,
      });
    });
    this.compositor.event.onWindowResize((event) => {
      getState(event.window, state.rect).set(event.currentRect);
    });
    this.compositor.event.onWindowMove((event) => {
      getState(event.window, state.rect).set(event.currentRect);
    });

    // Final composition
    this.compositor.window.composition = this.composition;
  }

  private readonly composition: WindowCompositionFunction = (window) => {
    return (
      <ManagedWindow rect={getState(window, state.rect)()}>
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
}

export class Output {
  private readonly inner: OutputInfo;

  private readonly workspaces: FocusList<Workspace> = new FocusList();

  public constructor(inner: OutputInfo) {
    this.inner = inner;
  }
}

export class Workspace {
  private output: Output;

  private readonly windows: FocusList<Window> = new FocusList();

  private name: string | undefined;

  public constructor(output: Output, name?: string) {
    this.output = output;
    this.name = name;
  }
}

export class Window {
  private workspace: Workspace;

  private readonly inner: WaylandWindow;

  public constructor(inner: WaylandWindow, workspace: Workspace) {
    this.workspace = workspace;
    this.inner = inner;
  }
}
