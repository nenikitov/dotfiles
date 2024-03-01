import { Gtk, Widget } from "prelude";

import { Battery, type BatteryConfig } from "./battery";
import { Volume, type VolumeConfig } from "./volume";
import { Module } from "../module";

interface SystemStatusConfig {
  battery: Partial<BatteryConfig>;
  volume: Partial<VolumeConfig>;
}

const configDefault: SystemStatusConfig = {
  battery: {},
  volume: {},
};

export function SystemStatus(
  configPartial: Partial<SystemStatusConfig>
): (monitor: number) => Gtk.Widget {
  return (monitor) => {
    const config = Object.assign({}, configDefault, configPartial);

    return Module({
      child: Widget.Box({
        children: [Battery(config.battery)(monitor), Volume(config.volume)(monitor)],
      }),
    });
  };
}
