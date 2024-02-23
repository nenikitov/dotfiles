import { Service, Variable } from "prelude";
import { seconds } from "utils/time";

type KeyboardLed = "numlock" | "capslock" | "scrolllock";

interface KeyboardState {
  layout: string;
  submap: string;
  led: {
    caps: boolean;
    num: boolean;
    scroll: boolean;
  };
}

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

Service.Hyprland.connect("keyboard-layout", (_, keyboard: string, layout: string) => {
  changeState((state) => {
    state.layout = layout;
  });
});

Service.Hyprland.connect("submap", (_, submap: string) => {
  changeState((state) => {
    state.submap = submap;
  });
});

export const POLL_RATE = seconds(0.1);

export const Keyboard = Variable(
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
