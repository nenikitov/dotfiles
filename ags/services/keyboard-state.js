import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { seconds } from '../utils/time.js';

const POLL_RATE = seconds(0.1);

const Keyboard = Variable(
  /** @type {KeyboardState} */({
    layout: '',
    submap: '',
    led: {
      caps: false,
      num: false,
      scroll: false,
    },
  }),
  {}
);

/**
 * @param {KeyboardLed} led
 */
function createLedVariable(led) {
  const variable = Variable(false, {
    poll: [
      POLL_RATE,
      ['bash', '-c', `cat /sys/class/leds/input[0-9]*::${led}/brightness`],
      (out) => out.split('\n')[0] === '1',
    ],
  });

  const key = {
    capslock: 'caps',
    numlock: 'num',
    scrolllock: 'scroll',
  }[led];

  variable.connect('changed', () => {
    const newState = { ...Keyboard.value };
    newState.led[key] = variable.value;
    Keyboard.value = newState;
  });
}

createLedVariable('capslock');
createLedVariable('numlock');
createLedVariable('scrolllock');

export default Keyboard;
