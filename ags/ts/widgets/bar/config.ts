import Gtk from "gi://Gtk";

import { Workspaces } from "./modules/workspaces/";
import { Battery } from "./modules/battery/";
import { Clock } from "./modules/clock/";

type ModuleFactory = (config: any) => (monitor: number) => Gtk.Widget;

export const modules = {
  workspaces: Workspaces,
  battery: Battery,
  clock: Clock,
} as const satisfies Record<string, ModuleFactory>;

export type Module =
  // name
  | keyof typeof modules
  // [name, config]
  | {
      [K in keyof typeof modules]: [K, ...Parameters<(typeof modules)[K]>];
    }[keyof typeof modules];

export interface BarConfig {
  position: "top" | "bottom";
  layout: {
    start: Module[];
    center: Module[];
    end: Module[];
  };
}
