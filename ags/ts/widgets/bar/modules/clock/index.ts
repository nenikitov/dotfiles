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

export function Clock(config: Partial<ClockConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const configFull = Object.assign({}, configDefault, config);

    const timeBar = Utils.derive([time], (t) => t.format(configFull.format) || "");
    const timeTooltip = Utils.derive([time], (t) => t.format(configFull.formatTooltip) || "");

    return Module({
      className: "clock",
      // window: "clock",
      child: Widget.Label({ label: timeBar.bind(), useMarkup: true }),
      tooltip: timeTooltip.bind(),
    });
  };
}
