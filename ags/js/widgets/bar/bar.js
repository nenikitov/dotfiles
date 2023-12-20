import Widget from "resource:///com/github/Aylur/ags/widget.js";

import { Clock } from "./modules/clock/clock.js";
import { Workspaces } from "./modules/workspaces/workspaces.js";

/**
 * @typedef {import("gtk-3.0/gtk-3.0").Gtk.Widget} GtkWidget
 * @typedef {import("types/widgets/window.js").default} AgsWindow
 */

/**
 * @param {number} monitor
 * @returns {GtkWidget}
 */
function Start(monitor) {
  return Widget.Box({
    class_name: "start",
    hpack: "start",
    children: [Workspaces({ monitor })],
  });
}

/**
 * @param {number} monitor
 * @returns {GtkWidget}
 */
function Middle(monitor) {
  return Widget.Box({
    class_name: "middle",
  });
}

/**
 * @param {number} monitor
 * @returns {GtkWidget}
 */
function End(monitor) {
  return Widget.Box({
    class_name: "end",
    hpack: "end",
    children: [
      Clock({
        format: "%H:%M:%S\n%a %Y-%m-%d",
        formatTooltip: "%H:%M:%S\n%A\n%B %d, %Y\n%Z (%:z)",
      }),
    ],
  });
}

/**
 * @param {number} monitor
 * @returns {AgsWindow}
 */
export default function Bar(monitor) {
  return Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    exclusivity: "exclusive",
    monitor,
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "panel",
      start_widget: Start(monitor),
      center_widget: Middle(monitor),
      end_widget: End(monitor),
    }),
  });
}
