import Gtk from "gi://Gtk";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

import BatteryService from "resource:///com/github/Aylur/ags/service/battery.js";

interface BatteryConfig extends ModuleConfig {}

const configDefault: BatteryConfig = {
  vertical: false,
};

export function Battery(config: Partial<BatteryConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const configFull = Object.assign({}, configDefault, config);

    return Widget.Label({
      class_name: "battery" + (configFull.class ? ` ${configFull.class}` : ""),
      connections: [
        [
          BatteryService,
          (self) => {
            self.label = String(BatteryService.percent) + "%";
          },
        ],
      ],
    });
  };
}
