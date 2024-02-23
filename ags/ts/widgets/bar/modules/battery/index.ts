import { Gtk, Widget, Service } from "prelude";

import { ModuleConfig } from "../module";

interface BatteryConfig extends ModuleConfig {}

const configDefault: BatteryConfig = {
  vertical: false,
};

export function Battery(config: Partial<BatteryConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const configFull = Object.assign({}, configDefault, config);

    return Widget.Label({
      class_name: "battery" + (configFull.class ? ` ${configFull.class}` : ""),
      // TODO(nenikitov): `connections` is deprecated
      connections: [
        [
          Service.Battery,
          (self) => {
            self.label = String(Service.Battery.percent) + "%";
          },
        ],
      ],
    });
  };
}
