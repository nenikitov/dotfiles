import { Gtk, Widget } from "prelude";

import { BarConfig, modules, Module } from "./config.js";

function assignLayout(monitor: number, layout: Module[]): Gtk.Widget[] {
  return layout.map((m) => {
    return typeof m == "string"
      ? modules[m]({})(monitor)
      : // eslint-disable-next-line @typescript-eslint/no-explicit-any -- Config will be appropriate for the module it's associated with
        modules[m.name](m.config as any)(monitor);
  });
}

export function Bar(config: BarConfig): (monitor: number) => Gtk.Window {
  return (monitor) => {
    return Widget.Window({
      monitor,
      name: `bar-${monitor}`,
      class_name: "bar",
      anchor: [config.position, "left", "right"],
      exclusivity: "exclusive",
      child: Widget.CenterBox({
        start_widget: Widget.Box({
          class_name: "start",
          hexpand: true,
          children: assignLayout(monitor, config.layout.start),
        }),
        center_widget: Widget.Box({
          class_name: "center",
          hpack: "center",
          children: assignLayout(monitor, config.layout.center),
        }),
        end_widget: Widget.Box({
          class_name: "end",
          hexpand: true,
          hpack: "end",
          children: assignLayout(monitor, config.layout.end),
        }),
      }),
    });
  };
}

export * from "./config";
