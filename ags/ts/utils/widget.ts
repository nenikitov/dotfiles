import _Gdk from "gi://Gdk";
const Gdk: typeof import("gdk-3.0/gdk-3.0").default = _Gdk;

import { range } from "utils/iterator";

export function forEveryMonitor<T>(widget: (monitor: number) => T) {
  const count = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(count).map(widget);
}
