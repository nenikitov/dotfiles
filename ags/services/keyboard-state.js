import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

const KeyboardCaps = Variable(
  /** @type {0 | 1} */(0, { listen:  });
)

const Keyboard = Variable(
  /** @type {KeyboardState} */({
    layout: '',
    submap: '',
    locks: {
      caps: false,
      num: false,
      scroll: false,
    },
  }),
  {}
);
