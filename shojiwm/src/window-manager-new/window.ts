import { type WaylandWindow } from "shoji_wm";
import { type Workspace } from "./workspace";

export class Window {
  readonly info: WaylandWindow;
  #workspace: Workspace;

  public constructor(info: WaylandWindow, workspace: Workspace) {
    this.#workspace = workspace;
    this.info = info;
  }
}
