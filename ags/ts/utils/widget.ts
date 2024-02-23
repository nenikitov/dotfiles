import Gdk from "gi://Gdk";

import { range } from "utils/iterator";

export function forEveryMonitor<T>(widget: (monitor: number) => T) {
  const count = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(count).map(widget);
}
