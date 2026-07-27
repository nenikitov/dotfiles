import {
  ClientWindow,
  ManagedWindow,
  WindowBorder,
  COMPOSITOR,
  type WaylandWindow,
  type WindowCompositionFunction,
  type OutputInfo,
  createWindowState,
  seconds,
  cubicBezier,
} from "shoji_wm";
import { type WindowPosition } from "shoji_wm/types";
import { todo } from "../../util/assert";
import { playRectAnimation } from "../old/window-animation";

export const state = {
  rect: createWindowState<WindowPosition>("rect", {
    default: (window) => window.position,
  }),
} as const;

const border = 2;
const gap = 4;
const strut = 8;

export class Output {
  #handle: OutputInfo;
  #windows: WaylandWindow[];

  public constructor(handle: OutputInfo) {
    this.#handle = handle;
    this.#windows = [];
  }

  public get handle(): OutputInfo {
    return this.#handle;
  }

  public set handle(value: OutputInfo) {
    this.#handle = value;
  }

  public get windows(): readonly WaylandWindow[] {
    return this.#windows;
  }

  public addWindow(window: WaylandWindow): boolean {
    this.#windows.push(window);
    this.applyLayout();
    return true;
  }

  public removeWindow(window: WaylandWindow): boolean {
    const index = this.#windows.findIndex((w) => w.id === window.id);

    if (index < 0) {
      return false;
    }

    this.#windows.splice(index, 1);
    this.applyLayout();
    return true;
  }

  public applyLayout() {
    if (this.handle.resolution === undefined) {
      return;
    }

    let x = this.handle.position.x + strut;
    let y = this.handle.position.y + strut;

    let width = this.handle.resolution.width / this.handle.scale - 2 * strut;
    let height = this.handle.resolution.height / this.handle.scale - 2 * strut;

    let tileWidth =
      this.#windows.length <= 0 ?
        0
      : (width - (this.#windows.length - 1) * gap) / this.windows.length;
    let tileHeight = height;

    for (const window of this.#windows) {
      // For whatever reason setting state is insufficient, but playing an empty animation is
      playRectAnimation(
        window,
        state.rect,
        {
          x,
          y,
          width: tileWidth,
          height,
        },
        cubicBezier(0.05, 0.9, 0.1, 1.0),
        seconds(0.2),
      );
      x += tileWidth + gap;
    }
  }
}

export class WindowManager {
  #outputs: Output[];
  #activeOutput: number | null;

  public constructor() {
    this.#outputs = [];
    this.#activeOutput = null;

    this.updateOutputs(COMPOSITOR.output.outputs);

    // Keep track of windows
    COMPOSITOR.event.onFirstCommit((window) => {
      this.addWindow(window);
    });
    COMPOSITOR.event.onStartClose((window) => {
      this.removeWindow(window);
    });

    // Movement and resize
    // TODO: handle these to swap window order or modify column sizes, but not needed so far
    COMPOSITOR.event.onWindowMove(() => {});
    COMPOSITOR.event.onWindowResize(() => {});

    // Final composition
    COMPOSITOR.window.composition = this.#composition;
  }

  public updateOutputs(outputs: OutputInfo[]) {
    // Get all live outputs, reuse objects from existing array if possible
    const live = outputs.map((output) => {
      const inOutputs = this.#outputs.find(
        (o) => o.handle.name === output.name,
      );

      if (inOutputs === undefined) {
        return new Output(output);
      }

      inOutputs.handle = output;
      return inOutputs;
    });
    if (live.length === 0) {
      todo("Handle when all outputs are disconnected");
    }

    // Find where currently active output is or default to 0
    let active = 0;
    if (this.#activeOutput !== null) {
      const inLive = live.findIndex(
        (output) =>
          output.handle.name === this.#outputs[this.#activeOutput!].handle.name,
      );
      if (inLive >= 0) {
        active = inLive;
      }
    }

    // Move windows from removed output to an active
    const removed = this.#outputs.filter(
      (output) => !outputs.some((o) => o.name === output.handle.name),
    );
    for (const r of removed) {
      for (const w of r.windows) {
        live[active].addWindow(w);
      }
    }

    this.#outputs.splice(0, this.#outputs.length, ...live);
    this.#activeOutput = active;

    this.applyLayout();
  }

  public addWindow(window: WaylandWindow) {
    if (this.#activeOutput !== null) {
      return this.#outputs[this.#activeOutput].addWindow(window);
    }
    return false;
  }

  public removeWindow(window: WaylandWindow): boolean {
    for (const output of this.#outputs) {
      if (output.removeWindow(window)) {
        return true;
      }
    }
    return false;
  }

  public applyLayout() {
    for (const output of this.#outputs) {
      output.applyLayout();
    }
  }

  readonly #composition: WindowCompositionFunction = (window) => {
    return (
      <ManagedWindow rect={window.state[state.rect]} forceRectSize>
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
