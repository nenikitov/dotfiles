import { FocusListStrict } from "../../util/focus-list";

export class Layout {
  readonly outputs: FocusListStrict<Output>;

  public constructor() {
    this.outputs = new FocusListStrict();
  }
}

export class Output {}
