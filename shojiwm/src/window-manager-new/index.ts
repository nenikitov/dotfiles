// The hierarchy is
// - Monitor -> Workspace -> Strip (column for horizontal scrolling, row for vertical) -> Window

import { type CompositorDefinition, type WaylandWindow } from "shoji_wm";
import { type Config, defaults } from "./config";
import { type PartialDeep } from "../util/partial-deep";
import { mergeWith } from "lodash-es";

export class WindowManager {
  private config: Config = defaults;
  private readonly monitors = new Array<Monitor>();

  constructor(private readonly compositor: CompositorDefinition) {}

  public configure(config: PartialDeep<Config>) {
    this.config = mergeWith(this.config, config, (obj, src) => {
      if (Array.isArray(obj) && Array.isArray(src)) {
        return obj.concat(src);
      }
    });
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
