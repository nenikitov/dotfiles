type KeyboardLed = 'numlock' | 'capslock' | 'scrolllock';

interface KeyboardState {
  layout: string;
  submap: string;
  led: {
    caps: boolean;
    num: boolean;
    scroll: boolean;
  };
}
