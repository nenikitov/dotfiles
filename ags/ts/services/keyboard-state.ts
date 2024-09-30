import { Service, Variable } from "prelude";
import { seconds } from "utils/time";

type KeyboardLed = "numlock" | "capslock" | "scrolllock";

const POLL_RATE = seconds(0.25);

export interface KeyboardState {
  layout: string;
  submap?: string;
  led: {
    caps: boolean;
    num: boolean;
    scroll: boolean;
  };
}

export const Keyboard = Variable<KeyboardState>({
  layout: getInitialLayout(),
  led: {
    caps: false,
    num: false,
    scroll: false,
  },
});

Service.Hyprland.connect("submap", (_, submap: string) => {
  updateState((s) => {
    s.submap = submap === "" ? undefined : submap;
  });
});

Service.Hyprland.connect("keyboard-layout", (_, _keyboard: string, layout: string) => {
  updateState((s) => {
    s.layout = layout;
  });
});

createLedVariable("capslock");
createLedVariable("numlock");
createLedVariable("scrolllock");

function createLedVariable(led: KeyboardLed) {
  const key = (
    {
      numlock: "num",
      capslock: "caps",
      scrolllock: "scroll",
    } as const satisfies Record<KeyboardLed, keyof KeyboardState["led"]>
  )[led];

  const variable = Variable(false, {
    poll: [
      POLL_RATE,
      ["bash", "-c", `cat /sys/class/leds/input[0-9]*::${led}/brightness`],
      (out) => out.split("\n")[0].trim() === "1",
    ],
  });

  variable.connect("changed", (v) => {
    updateState((s) => {
      s.led[key] = v.value;
    });
  });
}

function updateState(update: (state: KeyboardState) => void) {
  const value = { ...Keyboard.value };
  update(value);
  Keyboard.value = value;
}

interface Devices {
  keyboards: {
    address: string;
    name: string;
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
  }[];
}

function getInitialLayout(): string {
  const devices = JSON.parse(Service.Hyprland.message("j/devices")) as Devices;
  const keyboard = devices.keyboards.find((k) => k.main);

  return keyboard?.active_keymap ?? "";
}
