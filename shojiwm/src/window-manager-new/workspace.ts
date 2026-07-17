import { FocusListStrict } from "../util/focus-list";
import { type Output } from "./output";

export class Workspace {
  readonly #windows: FocusListStrict<Window>;

  #output: Output;
  #outputOriginal: Output;

  public name?: string;

  public constructor(output: Output, name?: string) {
    this.#windows = new FocusListStrict();
    this.#output = output;
    this.#outputOriginal = output;
    this.name = name;
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

  public get outputOriginal(): Output {
    return this.#outputOriginal;
  }

  public rememberOriginal() {
    this.#outputOriginal = this.output;
  }
}
