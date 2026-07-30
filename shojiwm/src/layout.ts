import {
  COMPOSITOR,
  type OutputInfo,
  type WaylandWindow,
  type WindowPosition,
} from "shoji_wm";
import { FocusList } from "./util/focus-list";
import { Sides } from "./util/measurement";

export class Layout {
  #outputs: FocusList<Output>;

  #isInOverview: boolean;

  constructor() {
    this.#outputs = new FocusList();
    this.#isInOverview = false;
  }

  updateOutputs(handles: OutputInfo[]) {
    const incomingOutputs = handles
      .filter((handle) => handle.enabled)
      .map((handle) => new Output(handle));

    const removedOutputs = new Set(
      this.#outputs.items.map((output) => output.value),
    );

    this.#outputs.setItems(incomingOutputs, {
      equalityCheck: (existing, incoming) => {
        // TODO: Should I check for more natural match like monitor serial, so monitors getting plugged into a different port doesn't influence the layout
        // Or is it connector more intuitive for managing external displays with a laptop
        const isMatch = existing.handle.name === incoming.handle.name;

        if (isMatch) {
          existing.handle = incoming.handle;
          removedOutputs.delete(existing);
        }

        return isMatch;
      },
    });

    // TODO: Handle migration from orphaned workspaces and non-original monitors
  }

  manageWindow(window: WaylandWindow) {}
}

export interface OutputRects {
  full: WindowPosition;
  borderless: WindowPosition;
  safe: WindowPosition;
}

export class Output {
  #handle: OutputInfo;

  #workspaces: FocusList<Workspace>;

  #struts: Sides<number>;

  constructor(handle: OutputInfo) {
    this.#handle = handle;

    this.#workspaces = new FocusList(
      Array.from({ length: 5 }, () => new Workspace(this)),
    );

    this.#struts = new Sides(6);
  }

  get handle(): OutputInfo {
    return this.#handle;
  }

  /** @package */
  set handle(value: OutputInfo) {
    this.#handle = value;
  }

  get workspaces(): readonly Workspace[] {
    return this.#workspaces.values;
  }

  get rects(): OutputRects | undefined {
    if (this.#handle.resolution === undefined) {
      return undefined;
    }

    const full: WindowPosition = {
      x: this.#handle.position.x,
      y: this.#handle.position.y,
      width: this.#handle.resolution.width / this.#handle.scale,
      height: this.#handle.resolution.height / this.#handle.scale,
    };

    const borderless = COMPOSITOR.layer.usableArea(this.#handle.name);
    if (borderless === null) {
      return undefined;
    }

    const safe: WindowPosition = {
      x: borderless.x + this.#struts.left,
      y: borderless.y + this.#struts.top,
      width: borderless.width - this.#struts.left - this.#struts.right,
      height: borderless.height - this.#struts.top - this.#struts.bottom,
    };

    return {
      full,
      borderless,
      safe,
    };
  }
}

class Workspace {
  parent: Output | undefined;

  floating: Floating;

  constructor(parent: Output | undefined) {
    this.parent = parent;
    this.floating = new Floating(this);
  }

  manageWindow(handle: WaylandWindow): Window {
    return this.floating.manageWindow(handle);
  }
}

class Floating {
  parent: Workspace;

  windows: FocusList<Window>;

  constructor(parent: Workspace) {
    this.parent = parent;
    this.windows = new FocusList();
  }

  manageWindow(window: WaylandWindow | Window): Window {
    let managed: Window;
    if (window instanceof Window) {
      window.manage(this);
      managed = window;
    } else {
      managed = new Window(window, this);
    }

    this.windows.insertLast([managed]);

    if (managed.position.floating === undefined) {
      const target = managed.handle.position;
      const rects = this.parent.parent!.rects!;

      if (managed.handle.isFullscreen.peek()) {
        managed.position.floating = rects.full;
      } else {
        managed.position.floating = {
          x: rects.safe.x - (rects.safe.width - target.width) / 2,
          y: rects.safe.y - (rects.safe.height - target.height) / 2,
          width: target.width,
          height: target.height,
        };
      }
    }

    return managed;
  }

  unmanageWindow(handle: WaylandWindow): boolean {
    const index = this.windows.items.findIndex(
      (window) => window.value.handle.id === handle.id,
    );
    if (index < 0) {
      return false;
    }

    const window = this.windows.removeAt(index)!.value;
    window.unmanage();

    return true;
  }
}

class Window {
  handle: WaylandWindow;

  parent: Floating | undefined;
  position: { floating: WindowPosition | undefined };

  constructor(handle: WaylandWindow, parent?: Floating) {
    this.handle = handle;
    this.parent = parent;
    this.position = { floating: undefined };
  }

  manage(parent: Floating) {
    this.parent = parent;
  }

  unmanage() {
    this.parent = undefined;
  }
}
