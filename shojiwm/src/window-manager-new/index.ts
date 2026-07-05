// The hierarchy is
// - Monitor -> Workspace -> Strip (column for horizontal scrolling, row for vertical) -> Window

import { type CompositorDefinition, type WaylandWindow } from "shoji_wm";
import { type Config, defaults } from "./config";
import { type PartialDeep } from "../util/partial-deep";
import { mergeWith } from "lodash-es";
import { Match, type WindowState } from "./match";

export class WindowManager {
  private config: Config = defaults;
  private readonly windows: WaylandWindow[] = [];

  constructor(private readonly compositor: CompositorDefinition) {
    // Register windows
    this.compositor.event.onFirstCommit((window) => {
      this.windows.push(window);
    });
    this.compositor.event.onClose((window) => {
      const index = this.windowStates.findIndex(
        Match.window({ id: Match.eq(window.id) }).matches,
      );
      if (index !== -1) {
        this.windows.splice(index, 1);
      }
    });
  }

  public configure(config: PartialDeep<Config>) {
    this.config = mergeWith(this.config, config, (obj, src) => {
      if (Array.isArray(obj) && Array.isArray(src)) {
        return obj.concat(src);
      }
    });
  }

  public windowClose(matcher: Match<WindowState>) {
    const target = this.windowStates.find(matcher.matches);
    if (target !== undefined) {
      target.info.close();
    }
  }

  private get windowStates(): WindowState[] {
    return this.windows.map((info) => ({
      info,
    }));
  }
}

export class Monitor {
  private readonly workspaces = new Array<Workspace>();
}

export class Workspace {
  private readonly ribbons = new Array<Strip>();
  private readonly floating = new Array<WaylandWindow>();
}

export class Strip {
  private readonly windows = new Array<WaylandWindow>();
}
