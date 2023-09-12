interface KeyboardState {
  layout: string;
  submap: string;
  locks: {
    caps: boolean;
    num: boolean;
    scroll: boolean;
  };
}
