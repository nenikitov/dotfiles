import { COMPOSITOR } from "shoji_wm";
import { Layout } from "./layout";

export class WindowManager {
  readonly #layout: Layout;

  public constructor() {
    this.#layout = new Layout();

    // Keep track of outputs
    COMPOSITOR.event.onOutputChange((event) => {
      this.#layout.updateOutputs(event.outputs);
    });

    // Keep track of windows
    COMPOSITOR.event.onFirstCommit((window) => {
      this.#layout.windowManage(window);
    });
    COMPOSITOR.event.onStartClose((window) => {
      // TODO: window.state[states.managed].close()
    });
  }
}
