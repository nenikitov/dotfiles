// The hierarchy is
// - Monitor -> Workspace -> Strip (column for horizontal scrolling, row for vertical) -> Window

import {
  ClientWindow,
  ManagedWindow,
  WindowBorder,
  type CompositorDefinition,
  type WaylandWindow,
  type WindowCompositionFunction,
} from "shoji_wm";
import { type Config, defaults } from "./config";
import { type PartialDeep } from "../util/partial-deep";
import { mergeWith } from "lodash-es";
import { Match, type WindowState } from "./match";
import { getState, state } from "./state";

const border = 2;

export class WindowManager {
  private config: Config = defaults;
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

  public configure(config: PartialDeep<Config>) {
    this.config = mergeWith(this.config, config, (obj, src) => {
      if (Array.isArray(obj) && Array.isArray(src)) {
        return obj.concat(src);
      }
    });
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
