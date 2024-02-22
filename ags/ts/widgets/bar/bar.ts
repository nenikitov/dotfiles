import Widget from "resource:///com/github/Aylur/ags/widget.js";

import { Clock } from "./modules/clock/clock.js";
import { Workspaces } from "./modules/workspaces/workspaces.js";
import { Battery } from "./modules/battery/battery.js";

type GtkWidget = import("gtk-3.0/gtk-3.0").Gtk.Widget;
type AgsWindow = import("types/widgets/window.js").default;

function Start(monitor: number): GtkWidget {
  return Widget.Box({
    class_name: "start",
    hpack: "start",
    children: [Workspaces({ monitor })],
  });
}

function Middle(monitor: number): GtkWidget {
  return Widget.Box({
    class_name: "middle",
  });
}

function End(monitor: number): GtkWidget {
  return Widget.Box({
    class_name: "end",
    hpack: "end",
    children: [
      Battery({}),
      Clock({
        format: "%H:%M:%S\n%a %Y-%m-%d",
        formatTooltip: "%H:%M:%S\n%A\n%B %d, %Y\n%Z (%:z)",
      }),
    ],
  });
}

export default function Bar(monitor: number): AgsWindow {
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
