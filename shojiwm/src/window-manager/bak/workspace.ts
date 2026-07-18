import { FocusListStrict } from "../util/focus-list";
import { type Output } from "./output";

export class Workspace {
  readonly #windows: FocusListStrict<Window>;

  #output: Output;

  public constructor(output: Output) {
    this.#windows = new FocusListStrict();
    this.#output = output;
  }

  public get isDirty(): boolean {
    return this.#windows.length !== 0;
  }

  public get output(): Output {
    return this.#output;
  }

  public set output(value: Output) {
    this.#output = value;
  }
}
