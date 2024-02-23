import Widget from "resource:///com/github/Aylur/ags/widget.js";

import type AgsWindow from "types/widgets/window.js";
import Gtk from "gi://Gtk";

import { BarConfig, modules, Module } from "./config.js";
export * from "./config.js";

function assignLayout(monitor: number, layout: Module[]): Gtk.Widget[] {
  return layout.map((m) => {
    return typeof m == "string"
      ? modules[m]({})(monitor)
      : modules[m.name](m.config as any)(monitor);
  });
}

export default function Bar(config: BarConfig): (monitor: number) => AgsWindow {
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
