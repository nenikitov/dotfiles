import { type OutputInfo } from "shoji_wm";
import { FocusListDynamic } from "../util/focus-list";
import { Workspace } from "./workspace";

export class Output {
  #info: OutputInfo;
  readonly #workspaces: FocusListDynamic<Workspace>;

  public constructor(info: OutputInfo, workspaces: Workspace[] = []) {
    this.#workspaces = new FocusListDynamic<Workspace>(
      () => new Workspace(this),
      (workspace) => !workspace.isDirty,
      workspaces,
    );
    this.#info = info;
  }

  public get info(): OutputInfo {
    return this.#info;
  }

  public set info(value: OutputInfo) {
    this.#info = value;
  }

  public get workspaces(): FocusListDynamic<Workspace> {
    return this.#workspaces;
  }

  public setWorkspace(index: number) {
    this.#workspaces.setActive("index", index);
  }

  public addWorkspaces(
    ...args:
      | [method: "first" | "last", ...workspaces: Workspace[]]
      | [method: "index", index: number, ...workspaces: Workspace[]]
      | [method: "relative", index: number, ...workspaces: Workspace[]]
  ) {
    const added = this.#workspaces.push(...args);
    for (const a of added) {
      a.output = this;
    }
  }
}
