import { Gdk } from "prelude";
import { range } from "utils/iterator";

export function forEveryMonitor<T>(widget: (monitor: number) => T) {
  const count = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(count).map(widget);
}

export function treatClassNames(className: string | (string | undefined)[] | undefined): string[] {
  if (!className) {
    return [];
  } else if (typeof className === "string") {
    return [className];
  } else {
    return className.filter(Boolean) as string[];
  }
}
