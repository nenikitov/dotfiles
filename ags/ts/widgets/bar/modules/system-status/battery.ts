import { Gtk, Widget, Service } from "prelude";
import { Battery as BatteryStatus } from "types/service/battery";
import { formatSeconds } from "utils/time";

export interface BatteryConfig {
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

export function Battery(configPartial: Partial<BatteryConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const config = Object.assign({}, configDefault, configPartial);

    return Widget.Box({
      className: "battery",
      children: [
        Widget.Icon({
          // TODO(nenikitov): Figure out why this isn't working
          visible: config.icon,
          icon: Service.Battery.bind("icon_name"),
        }),
        Widget.Label({
          useMarkup: true,
          visible: Boolean(config.format),
          setup: (self) => {
            if (typeof config.format === "function") {
              const format = config.format;
              self.hook(Service.Battery, (_) => {
                self.label = format(Service.Battery);
              });
            }
          },
        }),
      ],
      visible: Service.Battery.bind("available"),
      setup: (self) => {
        self.hook(
          Service.Battery,
          (self) => (self.tooltip_markup = config.formatTooltip(Service.Battery))
        );
      },
    });
  };
}
