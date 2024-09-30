import { TrayItem } from "resource:///com/github/Aylur/ags/service/systemtray.js";

import { Gtk, Widget } from "prelude";

import { SystemTrayConfig } from ".";

export function SystemTrayItem(config: SystemTrayConfig): (item: TrayItem) => Gtk.Widget {
  return (item) => {
    return Widget.Button({
      child: Widget.Icon({
        icon: item.bind("icon"),
      }),
      tooltipMarkup: item.bind("tooltip_markup"),
      onPrimaryClick: (_, event) => item.activate(event),
      onSecondaryClick: (_, event) => item.openMenu(event),
    });
  };
}
