import { Gtk, GLib, Widget } from "prelude";
import { seconds } from "utils/time";

import { ModuleConfig } from "../module";

interface ClockConfig extends ModuleConfig {
  format: string;
  formatTooltip: string;
  interval: number;
}

const configDefault: ClockConfig = {
  format: "%X",
  formatTooltip: "%c",
  interval: seconds(1),
  vertical: false,
};

export function Clock(config: Partial<ClockConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const configFull = Object.assign({}, configDefault, config);

    return Widget.Label({
      class_name: "clock" + (configFull.class ? ` ${configFull.class}` : ""),
      justification: "center",
      angle: config.vertical ? 90 : 0,
      // TODO(nenikitov): `connections` is deprecated
      connections: [
        [
          configFull.interval,
          (label) => {
            const date = GLib.DateTime.new_now_local();
            label.label = date.format(configFull.format) || "";
            label.tooltip_text = date.format(configFull.formatTooltip);
          },
        ],
      ],
    });
  };
}
