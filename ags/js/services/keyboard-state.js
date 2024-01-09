import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

import { seconds } from "../utils/time.js";

const POLL_RATE = seconds(0.1);

const Keyboard = Variable(
  /** @type {KeyboardState} */ ({
    layout: "",
    submap: "",
    led: {
      caps: false,
      num: false,
      scroll: false,
    },
  }),
  {}
);

/**
 * @param {(state: KeyboardState) => void} transform
 */
function changeState(transform) {
  const newState = { ...Keyboard.value };
  transform(newState);
  Keyboard.value = newState;
}

/**
 * @param {KeyboardLed} led
 */
function createLedVariable(led) {
  const variable = Variable(false, {
    poll: [
      POLL_RATE,
      ["bash", "-c", `cat /sys/class/leds/input[0-9]*::${led}/brightness`],
      (out) => out.split("\n")[0].trim() === "1",
    ],
  });

  const key =
    /** @type {{[key: string]: keyof KeyboardState["led"]}} */
    ({
      capslock: "caps",
      numlock: "num",
      scrolllock: "scroll",
    })[led];

  variable.connect("changed", () => {
    changeState((state) => {
      state.led[key] = variable.value;
    });
  });
}

createLedVariable("capslock");
createLedVariable("numlock");
createLedVariable("scrolllock");

Hyprland.connect(
  "keyboard-layout",
  /**
   * @param {string} keyboard
   * @param {string} layout
   */
  (_, keyboard, layout) => {
    changeState((state) => {
      state.layout = layout;
    });
  }
);

Hyprland.connect(
  "submap",
  /**
   * @param {string} submap
   */
  (_, submap) => {
    changeState((state) => {
      state.submap = submap;
    });
  }
);

export default Keyboard;
