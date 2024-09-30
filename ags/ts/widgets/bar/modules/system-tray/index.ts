import { Gtk, Widget, Utils, Service } from "prelude";

import { SystemTrayItem } from "./tray-item";
import { Module } from "../module";

export interface SystemTrayConfig {}

const configDefault: SystemTrayConfig = {};

export function SystemTray(
  configPartial: Partial<SystemTrayConfig>
): (monitor: number) => Gtk.Widget {
  const config = Object.assign({}, configDefault, configPartial);

  return (_) => {
    return Widget.Box({
      className: "system-tray",
      child: Widget.Box({
        children: Service.SystemTray.bind("items").as((i) => i.map(SystemTrayItem(config))),
      }),
    });
  };
}
