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
import { FocusListStrict } from "../util/focus-list";
import { Output } from "./output";
import type { Workspace } from "./workspace";

// TODO: Should be in the config
const border = 2;

export class WindowManager {
  readonly #windows: WaylandWindow[] = [];

  readonly #compositor: CompositorDefinition;
  readonly #outputs: FocusListStrict<Output>;
  readonly #orphanedWorkspaces: Workspace[];

  public constructor(compositor: CompositorDefinition) {
    this.#compositor = compositor;
    this.#outputs = new FocusListStrict();
    this.#orphanedWorkspaces = [];

    // Register outputs
    this.#updateOutputs(this.#compositor.output.outputs, []);
    this.#compositor.event.onOutputChange((event) => {
      this.#updateOutputs(event.outputs, event.removed);
    });

    // Keep track of windows
    this.#compositor.event.onFirstCommit((window) => {
      this.#windows.push(window);
    });
    this.#compositor.event.onClose((window) => {
      const index = this.#windows.findIndex((w) => w.id === window.id);
      if (index !== -1) {
        this.#windows.splice(index, 1);
      }
    });

    // Register rect
    this.#compositor.event.onFirstCommit((window) => {
      getState(window, state.rect).set({
        x: window.rect.x - border,
        y: window.rect.y - border,
        width: window.rect.width + 2 * border,
        height: window.rect.height + 2 * border,
      });
    });
    this.#compositor.event.onWindowResize((event) => {
      getState(event.window, state.rect).set(event.currentRect);
    });
    this.#compositor.event.onWindowMove((event) => {
      getState(event.window, state.rect).set(event.currentRect);
    });

    // Final composition
    this.#compositor.window.composition = this.#composition;
  }

  public get outputs(): FocusListStrict<Output> {
    return this.#outputs;
  }

  public outputActivate(index: number) {
    this.#outputs.setActive("index", index);
  }

  public workspaceActivate(index: number) {
    this.#outputs.getActive("object")?.workspaceActivate(index);
  }

  #updateOutputs(liveInfos: OutputInfo[], removedInfos: OutputInfo[]) {
    const live = liveInfos
      .filter((l) => l.enabled)
      .map((l) => {
        const inOutputs = this.#outputs.items.find(
          (o) => o.info.name === l.name,
        );
        if (!inOutputs) {
          // TODO: Generate workspaces from config
          return new Output(l);
        }
        inOutputs.info = l;
        return inOutputs;
      });

    // TODO: Restore workspaces to their original monitors

    const active = live.some(
      (l) => l.info.name === this.#outputs.getActive("object")?.info.name,
    )
      ? this.#outputs.getActive("object")
      : live.at(0);

    for (const removed of removedInfos) {
      const inOutputs = this.#outputs.items.find(
        (output) => output.info.name === removed.name,
      );
      if (inOutputs) {
        const workspaces = inOutputs.workspaces.items.filter((w) => w.isDirty);

        if (active) {
          for (const workspace of workspaces) {
            workspace.output = active;
          }
          active.workspaceAdd("last", ...workspaces);
        } else {
          this.#orphanedWorkspaces.push(...workspaces);
        }
      }
    }

    this.#outputs.rebuild(live);
    if (active) {
      this.#outputs.setActive("object", active);
    }
  }

  readonly #composition: WindowCompositionFunction = (window) => {
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
