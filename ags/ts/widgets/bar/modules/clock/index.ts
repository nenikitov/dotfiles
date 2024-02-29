import { Gtk, Widget, Utils } from "prelude";
import { time } from "services/time";

import { Module } from "../module";

interface ClockConfig {
  format: string;
  formatTooltip: string;
}

const configDefault: ClockConfig = {
  format: "%X",
  formatTooltip: "%c",
};

export function Clock(configPartial: Partial<ClockConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const config = Object.assign({}, configDefault, configPartial);

    const timeBar = Utils.derive([time], (t) => t.format(config.format) || "");
    const timeTooltip = Utils.derive([time], (t) => t.format(config.formatTooltip) || "");

    return Module({
      className: "clock",
      window: "clock",
      child: Widget.Label({ label: timeBar.bind(), useMarkup: true }),
      tooltip: timeTooltip.bind(),
    });
  };
}
