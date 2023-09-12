import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { seconds } from '../utils/time.js';

const KeyboardCaps = Variable(/** @type {LedState} */ (0), {
  poll: [seconds(0.1), () => {}],
});

const Keyboard = Variable(
  /** @type {KeyboardState} */ ({
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
