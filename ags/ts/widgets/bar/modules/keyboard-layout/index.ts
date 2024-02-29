import { Gtk, Widget } from "prelude";
import { Keyboard, type KeyboardState } from "services/keyboard-state";

import { Module } from "../module";

interface KeyboardLayoutConfig {
  format: (keyboard: KeyboardState) => string;
  formatTooltip: (keyboard: KeyboardState) => string;
}

const configDefault: KeyboardLayoutConfig = {
  format: function (keyboard: KeyboardState): string {
    return keyboard.layout;
  },
  formatTooltip: function (keyboard: KeyboardState): string {
    return [
      `Layout ${keyboard.layout}`,
      keyboard.submap ? `Submap ${keyboard.submap}` : undefined,
      keyboard.led.caps ? "Caps lock" : undefined,
      keyboard.led.num ? "Num lock" : undefined,
      keyboard.led.scroll ? "Scroll lock" : undefined,
    ]
      .filter(Boolean)
      .join("\n");
  },
};

export function KeyboardLayout(
  configPartial: Partial<KeyboardLayoutConfig>
): (monitor: number) => Gtk.Widget {
  return (_) => {
    const config = Object.assign({}, configDefault, configPartial);

    return Module({
      className: "keyboard-layout",
      child: Widget.Label({
        useMarkup: true,
        setup: (self) => {
          self.hook(Keyboard, (_) => {
            self.label = config.format(Keyboard.value);
          });
        },
      }),
      tooltip: [Keyboard, () => config.formatTooltip(Keyboard.value)],
    });
  };
}
