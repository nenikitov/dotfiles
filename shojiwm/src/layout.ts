import type { OutputInfo } from "shoji_wm";
import { FocusList } from "./util/focus-list";

export class Layout {
  #outputs: FocusList<Output>;
  #orphanedWorkspaces: Workspace[];

  #isInOverview: boolean;

  constructor() {
    this.#outputs = new FocusList();
    this.#orphanedWorkspaces = [];
    this.#isInOverview = false;
  }

  updateOutputs(handles: OutputInfo[]) {
    const incomingOutputs = handles
      .filter((handle) => handle.enabled)
      .map((handle) => new Output(handle));

    const removedOutputs = new Set(
      this.#outputs.items.map((output) => output.item),
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

    for (const removed of removedOutputs) {
      for (const [w, workspace] of removed.workspaces.entries()) {
        workspace.originalOutput = [removed, w];
        this.#orphanedWorkspaces.push(workspace);
      }
      removed.handle.enabled = false;
      removed.workspaces = [];
    }
  }
}

export class Output {
  #handle: OutputInfo;
  #workspaces: Workspace[];

  constructor(handle: OutputInfo) {
    this.#handle = handle;
    this.#workspaces = [];
  }

  get handle(): OutputInfo {
    return this.#handle;
  }

  /** @package */
  set handle(value: OutputInfo) {
    this.#handle = value;
  }

  get workspaces(): readonly Workspace[] {
    return this.#workspaces;
  }

  /** @package */
  set workspaces(value: Workspace[]) {
    this.#workspaces = value;
  }
}

class Workspace {
  parent: Output | undefined;
  originalOutput: [Output, number] | undefined;
}
