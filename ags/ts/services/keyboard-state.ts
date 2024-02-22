import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

import { seconds } from "../utils/time.js";

export const POLL_RATE = seconds(0.1);

const Keyboard = Variable(
  /** @type {KeyboardState} */ {
    layout: "",
    submap: "",
    led: {
      caps: false,
      num: false,
      scroll: false,
    },
  },
  {}
);

function changeState(transform: (state: KeyboardState) => void) {
  const newState = { ...Keyboard.value };
  transform(newState);
  Keyboard.value = newState;
}

function createLedVariable(led: KeyboardLed) {
  const variable = Variable(false, {
    poll: [
      POLL_RATE,
      ["bash", "-c", `cat /sys/class/leds/input[0-9]*::${led}/brightness`],
      (out) => out.split("\n")[0].trim() === "1",
    ],
  });

  const key = (
    {
      capslock: "caps",
      numlock: "num",
      scrolllock: "scroll",
    } as const
  )[led];

  variable.connect("changed", () => {
    changeState((state) => {
      state.led[key] = variable.value;
    });
  });
}

createLedVariable("capslock");
createLedVariable("numlock");
createLedVariable("scrolllock");

Hyprland.connect("keyboard-layout", (_, keyboard: string, layout: string) => {
  changeState((state) => {
    state.layout = layout;
  });
});

Hyprland.connect("submap", (_, submap: string) => {
  changeState((state) => {
    state.submap = submap;
  });
});

export default Keyboard;
