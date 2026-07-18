import { type WaylandWindow } from "shoji_wm";
import { type ManagedWindowRect } from "shoji_wm/types";
import { type Output } from "./output";
import { state } from "../state";

export class Window {
  public readonly info: WaylandWindow;
  public parent: Output | null;

  // Position in global coordinates
  public rect: ManagedWindowRect;

  public constructor(info: WaylandWindow) {
    this.info = info;
    this.parent = null;
    this.rect = { x: 0, y: 0, width: 0, height: 0 };
  }

  public display(rect: ManagedWindowRect) {
    this.info.state[state.rect].set(rect);
  }
}
