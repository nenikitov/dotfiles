import { Gtk } from "prelude";

import { Battery } from "./modules/battery";
import { Clock } from "./modules/clock";
import { KeyboardLayout } from "./modules/keyboard-layout";
import { Workspaces } from "./modules/workspaces";

// eslint-disable-next-line @typescript-eslint/no-explicit-any -- It doesn't matter which parameter it uses, we only care that it's one
type ModuleFactory = (config: any) => (monitor: number) => Gtk.Widget;

export const modules = {
  battery: Battery,
  clock: Clock,
  keyboardLayout: KeyboardLayout,
  workspaces: Workspaces,
} as const satisfies Record<string, ModuleFactory>;

export type Module =
  // name
  | keyof typeof modules
  // { name, config }
  // TODO(nenikitov): I'd prefer this to be `[name, config]` instead, but discriminated unions don't work with tuples
  // See [issue](https://github.com/microsoft/TypeScript/issues/55632).
  // Make this an array when this gets fixed
  | {
      [K in keyof typeof modules]: { name: K; config: Parameters<(typeof modules)[K]>[0] };
    }[keyof typeof modules];

export interface BarConfig {
  position: "top" | "bottom";
  layout: {
    start: Module[];
    center: Module[];
    end: Module[];
  };
}
