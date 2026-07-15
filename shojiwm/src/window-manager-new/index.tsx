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

  private readonly workspaces: Workspace[];
  private activeWorkspace: Workspace | null;

  public constructor(inner: OutputInfo) {
    this.inner = inner;
    this.workspaces = [];
    this.activeWorkspace = null;
  }

  public addWorkspace(name?: string) {
    this.workspaces.push(new Workspace(this, name));
  }
}

export class Workspace {
  private output: Output;

  private readonly windows: Window[];
  private activeWindow: Window | undefined;

  private name: string | undefined;

  public constructor(output: Output, name?: string) {
    this.output = output;

    this.windows = [];
    this.activeWindow = undefined;

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

class FocusList<T> {
  private readonly inner: T[] = [];
  private _active: number | null = null;

  public get items(): readonly T[] {
    return this.inner;
  }

  public getActive(method: "index"): number | null;
  public getActive(method: "object"): T | null;
  public getActive(method: "index" | "object" = "index"): number | T | null {
    if (method == "index") {
      return this._active;
    } else {
      return this._active !== null ? this.inner[this._active] : null;
    }
  }

  public setActive(
    method: "index",
    value: number | null,
    outOfBounds: "clamp" | "unset",
  ): void;
  public setActive(method: "object", value: T | null): void;
  public setActive(
    method: "index" | "object",
    value: number | T | null,
    outOfBounds: "clamp" | "unset" = "clamp",
  ): void {
    if (value === null) {
      this._active = null;
      return;
    }

    if (method === "index") {
      value = value as number;

      if (this.inner.length === 0) {
        this._active = null;
        return;
      }

      if (value < 0) {
        value += this.inner.length;
      }

      if (value >= 0 && value < this.inner.length) {
        this._active = value;
      } else if (outOfBounds === "clamp") {
        this._active = Math.max(0, Math.min(value, this.inner.length - 1));
      } else {
        this._active = null;
      }
    } else {
      const index = this.inner.indexOf(value as T);
      this._active = index >= 0 ? index : null;
    }
  }

  public push(value: T, method: "first"): void;
  public push(value: T, method: "last"): void;
  public push(value: T, method: "index", index: number, factory: () => T): void;
  public push(value: T, method: "relative", index: 0 | -1): void;
  public push(
    value: T,
    method: "relative",
    index: number,
    factory: () => T,
  ): void;
  public push(
    value: T,
    method: "first" | "last" | "index" | "relative",
    index?: 0 | 1 | number,
    factory?: () => T,
  ): void {
    let target = 0;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length;
      }
      case "index": {
        if (index !== undefined) {
          target = index;
        }
        break;
      }
      case "relative": {
        if (index !== undefined) {
          target = Math.max(0, (this._active ?? 0) + index);
        }
        break;
      }
    }

    for (let i = this.inner.length; i < target; i++) {
      if (factory !== undefined) {
        this.inner.push(factory());
      }
    }

    this.inner.splice(target, 0, value);
  }
}
