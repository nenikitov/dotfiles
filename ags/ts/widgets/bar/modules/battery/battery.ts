import { Icon, Label } from "resource:///com/github/Aylur/ags/widget.js";

import BatteryService from "resource:///com/github/Aylur/ags/service/battery.js";

type BatteryStatus = typeof import("resource:///com/github/Aylur/ags/service/battery.js");

interface BatteryConfig extends ModuleConfig {
  formatTooltip(battery: BatteryStatus): string;
}

interface BatteryArgs extends Partial<BatteryConfig> {}

const defaultArgs: BatteryConfig = {
  formatTooltip: function (battery) {
    throw new Error("Function not implemented.");
  },
  vertical: false,
};

export function Battery(args: BatteryArgs) {
  const config = Object.assign({}, defaultArgs, args);

  return Label({
    class_name: "battery" + (args.class ? ` ${args.class}` : ""),
    connections: [
      [
        BatteryService,
        (self) => {
          self.label = String(BatteryService.percent) + "%";
        },
      ],
    ],
  });
}
