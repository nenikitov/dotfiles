import { Gtk, Widget, Service } from "prelude";
import { Battery as BatteryStatus } from "types/service/battery";
import { formatSeconds } from "utils/time";

import { Module } from "../module";

interface BatteryConfig {
  format: ((battery: BatteryStatus) => string) | false;
  icon: boolean;
  formatTooltip: (battery: BatteryStatus) => string;
}

const configDefault: BatteryConfig = {
  format: (battery) => {
    return `${battery.percent.toFixed()}%`;
  },
  icon: true,
  formatTooltip: (battery) => {
    return [
      `${battery.percent.toFixed()}%`,
      battery.charged
        ? "Charged"
        : battery.time_remaining
          ? formatSeconds(battery.time_remaining)
          : undefined,
      battery.charging ? "Charging" : undefined,
    ]
      .filter(Boolean)
      .join("\n");
  },
};

export function Battery(config: Partial<BatteryConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const configFull = Object.assign({}, configDefault, config);

    return Module({
      className: "battery",
      child: Widget.Box({
        children: [
          Widget.Icon({
            // TODO(nenikitov): Figure out why this isn't working
            visible: configFull.icon,
            icon: Service.Battery.bind("icon_name"),
          }),
          Widget.Label({
            useMarkup: true,
            visible: Boolean(configFull.format),
            setup: (self) => {
              if (typeof configFull.format === "function") {
                const format = configFull.format;
                self.hook(Service.Battery, (_) => {
                  self.label = format(Service.Battery);
                });
              }
            },
          }),
        ],
      }),
      tooltip: [Service.Battery, () => configFull.formatTooltip(Service.Battery)],
    });
  };
}
