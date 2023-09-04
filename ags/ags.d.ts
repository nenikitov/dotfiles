//#region Services

interface Service { }

declare module 'resource:///com/github/Aylur/ags/service/applications.js' {
  export interface App {
    app: object; // TODO
    name: string;
    desktop: string | null;
    description: string | null;
    executable: string;
    iconName: string;
    launch(): void;
    match(term: string): boolean;
  }

  interface Applications extends Service {
    query(term: string): App[];
  }

  const applications: Applications;
  export default applications;
}

declare module 'resource:///com/github/Aylur/ags/service/audio.js' {
  export interface Stream {
    name: string;
    description: string | null;
    iconNAme: string;
    id: number;
    isMuted: boolean;
    volume: number;
  }

  interface Audio extends Service {
    microphone: Stream;
    speaker: Stream;
    apps: Stream[];
    speakers: Stream[];
    microphones: Stream[];
  }

  const audio: Audio;
  export default audio;
}

declare module 'resource:///com/github/Aylur/ags/service/battery.js' {
  interface Battery extends Service {
    available: boolean;
    percent: number;
    charging: boolean;
    charged: boolean;
  }

  const battery: Battery;
  export default battery;
}

declare module 'resource:///com/github/Aylur/ags/service/bluetooth.js' {
  export interface Device {
    address: string;
    batteryLevel: number;
    batteryPercentage: number;
    connected: boolean;
    iconName: string;
    alias: string;
    name: string;
    trusted: boolean;
    paired: boolean;

    setConnection(connect: boolean): void;
  }

  interface Bluetooth extends Service {
    enabled: boolean;
    devices: Device[];
    connectedDevices: Device[];

    toggle(): void;
  }

  const bluetooth: Bluetooth;
  export default bluetooth;
}

declare module 'resource:///com/github/Aylur/ags/service/hyprland.js' {
  export interface Monitor {
    id: number;
    name: string;
    description: string;
    make: string;
    model: string;
    serial: string;
    width: number;
    height: number;
    refreshRate: number;
    x: number;
    y: number;
    activeWorkspace: WorkspaceShort;
    specialWorkspace: WorkspaceShort;
    reserved: [number, number, number, number];
    scale: number;
    transform: number;
    focused: boolean;
    dpmsStatus: boolean;
    vrr: boolean;
  }

  export interface WorkspaceShort {
    id: number;
    name: number;
  }

  export interface Workspace extends WorkspaceShort {
    monitor: string;
    windows: number;
    hasfullscreen: boolean;
    lastwindow: string;
    lastwindowtitle: string;
  }

  export interface ClientShort {
    address: string;
    title: string;
    class: string;
  }

  export interface Client extends ClientShort {
    mapped: boolean;
    hidden: boolean;
    monitor: number;
    at: [number, number];
    size: [number, number];
    workspace: WorkspaceShort;
    floating: boolean;
    initialClass: string;
    initialTitle: string;
    pid: number;
    xwayland: boolean;
    pinned: boolean;
    fullscreen: boolean;
    fullscreenMode: 0 | 1;
    fakeFullscreen: boolean;
    grouped: object[]; // TODO
    swallowing: null; // TODO
  }

  export interface LayerClient {
    address: string;
    x: number;
    y: number;
    w: number;
    h: number;
    namespace: string;
  }

  export interface Layer {
    levels: Record<'0' | '1' | '2' | '3', LayerClient[]>;
  }

  export interface Device {
    address: string;
    name: string;
  }

  export interface Mouse extends Device {
    defaultSpeed: number;
  }

  export interface Keyboard extends Device {
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
  }

  export interface Devices {
    mice: Mouse[];
    keyboards: Keyboard[];
    tablets: Device[]; // TODO
    touch: Device[];
    switches: Device[];
  }

  export interface Bind {
    locked: boolean;
    mouse: boolean;
    release: boolean;
    repeat: boolean;
    non_consuming: boolean;
    modmask: number;
    key: string;
    keycode: -1; // TODO
    dispatcher: string;
    arg: string;
  }

  export interface Version {
    branch: string;
    commit: string;
    dirty: boolean;
    commit_message: string;
    tag: string;
    flags: string[];
  }

  export interface Instance {
    instance: string;
    time: number;
    pid: number;
    wl_socket: string;
  }

  interface Hyprland extends Service {
    active: { client: ClientShort; monitor: string; workspace: WorkspaceShort };
    monitors: Map<number, Monitor>;
    workspaces: Map<number, Workspace>;
    clients: Map<string, Client>;

    HyprctlGet(cmd: 'monitors'): Monitor[];
    HyprctlGet(cmd: 'workspaces'): Workspace[];
    HyprctlGet(cmd: 'activeworkspace'): Workspace;
    HyprctlGet(cmd: 'clients'): Client[];
    HyprctlGet(cmd: 'activewindow'): Client;
    HyprctlGet(cmd: 'layers'): Record<string, Layer>;
    HyprctlGet(cmd: 'devices'): Devices;
    HyprctlGet(cmd: 'binds'): Bind[];
    HyprctlGet(cmd: 'version'): Version;
    HyprctlGet(cmd: 'splash'): string;
    HyprctlGet(cmd: 'cursorpos'): { x: number; y: number };
    HyprctlGet(cmd: 'globalshortcuts'): object[]; // TODO
    HyprctlGet(cmd: 'instances'): Instance[]; // TODO
    HyprctlGet(cmd: string): any;
  }

  const hyprland: Hyprland;
  export default hyprland;
}

declare module 'resource:///com/github/Aylur/ags/service/mpris.js' {
  export interface Player {
    busName: string;
    name: string;
    identity: string;
    entry: string;
    trackArtists: string[];
    trackTitle: string;
    trackCoverUrl: string;
    coverPath: string;
    playBackStatus: 'Playing' | 'Paused' | 'Stopped';
    canGoNext: boolean;
    canGoPrev: boolean;
    canPlay: boolean;
    shuffleStatus: boolean;
    loopStatus: 'None' | 'Track' | 'Playlist';
    volume: number;
    length: number;
    position: number;

    playPause(): void;
    play(): void;
    stop(): void;
    next(): void;
    previous(): void;
    shuffle(): void;
    loop(): void;
  }

  interface Mpris extends Service {
    getPlayer(name: string): Player | null;
    // TODO: add another `getPlayer`
  }

  const mpris: Mpris;
  export default mpris;
}

declare module 'resource:///com/github/Aylur/ags/service/network.js' {
  export type State =
    | 'unknown'
    | 'unmanaged'
    | 'unavailable'
    | 'disconnected'
    | 'prepare'
    | 'config'
    | 'need_auth'
    | 'ip_config'
    | 'ip_check'
    | 'secondaries'
    | 'activated'
    | 'deactivating'
    | 'failed';

  export type Internet = 'connected' | 'connecting' | 'disconnected';

  export interface AccessPoint {
    bssid: string;
    address: string;
    lastSeen: number;
    ssid: string;
    active: boolean;
    strength: number;
  }

  export interface Wired {
    internet: Internet;
    state: State;
  }

  export interface Wifi {
    ssid: string;
    strength: number;
    internet: Internet;
    enabled: boolean;
    accessPoints: AccessPoint[];
    state: State;

    scan(): void;
  }

  interface Network extends Service {
    connectivity: 'unknown' | 'none' | 'portal' | 'limited' | 'full';
    primary: 'wifi' | 'wired';
    wired?: Wired;
    wifi?: Wifi;
  }

  const network: Network;
  export default network;
}

declare module 'resource:///com/github/Aylur/ags/service/notifications.js' {
  export type Urgency = 'low' | 'normal' | 'critical';

  export interface Notification {
    id: number;
    appName: string;
    appEntry: string;
    appIcon: string;
    summary: string;
    body: string;
    actions: { action: string; label: string }[];
    urgency: Urgency;
    time: number;
    image: string | null;
  }

  interface Notifications extends Service {
    dnd: boolean;
    popups: Notification[];
    notifications: Notification[];

    clear(): void;
    invoke(id: number, action: string): void;
    close(id: number): void;
    dismiss(id: number): void;
  }

  const notifications: Notifications;
  export default notifications;
}

//#endregion

//#region App

declare module 'resource:///com/github/Aylur/ags/app.js' {
  interface App extends Service {
    windows: object[]; // TODO
    configDir: string;

    getWindow(name: string): object | undefined;
    closeWindow(name: string): void;
    openWindow(name: string): void;
    toggleWindow(name: string): void;
    quit(): void;
    resetCss(): void;
    applyCss(path: string): void;
  }

  const app: App;
  export default app;
}
//#endregion

//#region Widgets

interface Widget { }

declare module 'resource:///com/github/Aylur/ags/widget.js' {
  type Applications =
    typeof import('resource:///com/github/Aylur/ags/service/applications.js').default;
  type Audio =
    typeof import('resource:///com/github/Aylur/ags/service/audio.js').default;
  type Battery =
    typeof import('resource:///com/github/Aylur/ags/service/battery.js').default;
  type Bluetooth =
    typeof import('resource:///com/github/Aylur/ags/service/bluetooth.js').default;
  type Hyprland =
    typeof import('resource:///com/github/Aylur/ags/service/hyprland.js').default;
  type Mpris =
    typeof import('resource:///com/github/Aylur/ags/service/mpris.js').default;
  type Network =
    typeof import('resource:///com/github/Aylur/ags/service/network.js').default;
  type Notifications =
    typeof import('resource:///com/github/Aylur/ags/service/notifications.js').default;

  type Command<W extends Widget, Args extends any[] = never[]> = string | ((widget: W, ...args: Args) => void);
  type Justification = 'left' | 'center' | 'right' | 'fill';
  type Truncate = 'none' | 'start' | 'middle' | 'end';
  type Scroll = 'always' | 'automatic' | 'external' | 'never';
  type Anchor = 'top' | 'bottom' | 'left' | 'right';

  interface WindowArgs {
    child: Widget;
    name: string;
    anchor: Anchor | Anchor[];
    exclusive: boolean;
    focusable: boolean;
    layer: 'overlay' | 'top' | 'bottom' | 'background';
    margin:
    | number
    | [number]
    | [number, number]
    | [number, number, number]
    | [number, number, number, number];
    monitor: number;
    popup: boolean;
  }
  export function Window(args: Partial<WindowArgs>): Widget;

  type ConnectionBuilder<
    W extends Widget,
    Ser extends Service = Service,
    Sig extends string | undefined = undefined,
    Args extends any[] = never[]
  > = [Ser, Command<W>] | [Ser, Command<W>, 'changed'] | [Ser, Command<W, Args>, Sig];

  type Connection<W> =
    | ConnectionBuilder<W, Applications>
    | ConnectionBuilder<W, Audio, 'speaker-changed' | 'microphone-changed'>
    | ConnectionBuilder<W, Bluetooth>
    | ConnectionBuilder<W, Hyprland, 'urgent-window', [string]>;

  interface CommonArgs<W> {
    className: string;
    connections: Connection<W>[];
  }

  interface BoxArgs extends CommonArgs<BoxArgs> {
    children: Widget[];
    vertical: boolean;
  }
  export function Box(args: Partial<BoxArgs>): Widget & BoxArgs;

  interface ButtonArgs extends CommonArgs {
    child: Widget;
    onClicked: Command;
    onPrimaryClick: Command;
    onSecondaryClick: Command;
    onMiddleClick: Command;
    onPrimaryClickRelease: Command;
    onSecondaryClickRelease: Command;
    onMiddleClickRelease: Command;
    onScrollUp: Command;
    onScrollDown: Command;
  }
  export function Button(args: Partial<ButtonArgs>): Widget;

  interface ButtonArgs extends CommonArgs {
    startWidget: Widget;
    centerWidget: Widget;
    endWidget: Widget;
  }
  export function CenterBox(args: Partial<CenterBoxArgs>): Widget;

  interface EntryArgs extends CommonArgs {
    onChange: Command;
    onAccept: Command;
  }
  export function Entry(args: Partial<EntryArgs>): Widget;

  interface EventBoxArgs extends CommonArgs {
    child: Widget;
    onPrimaryClick: Command;
    onSecondaryClick: Command;
    onMiddleClick: Command;
    onPrimaryClickRelease: Command;
    onSecondaryClickRelease: Command;
    onMiddleClickRelease: Command;
    onHoverRelease: Command;
    onHoverLost: Command;
    onScrollUp: Command;
    onScrollDown: Command;
  }
  export function EventBox(args: Partial<EventBoxArgs>): Widget;

  interface IconArgs extends CommonArgs {
    icon: string;
    size: number;
  }
  export function Icon(args: Partial<IconArgs>): Widget;

  interface LabelArgs extends CommonArgs {
    justification: Justification;
    truncate: Truncate;
  }
  export function Label(args: Partial<LabelArgs>): Widget;

  interface OverlayArgs extends CommonArgs {
    child: Widget;
    overlays: Widget[];
    passthrough: boolean;
  }
  export function Overlay(args: Partial<OverlayArgs>): Widget;

  interface ProgressBarArgs extends CommonArgs {
    vertical: boolean;
    value: number;
  }
  export function ProgressBar(args: Partial<ProgressBarArgs>): Widget;

  interface RevealerArgs extends CommonArgs {
    child: Widget;
    transition: 'none' | 'crossfade' | 'slide_left' | 'slide_right' | 'slide_down' | 'slide_up';
  }
  export function Revealer(args: Partial<RevealerArgs>): Widget;

  interface ScrollableArgs extends CommonArgs {
    child: Widget;
    hscroll: Scroll;
    vscroll: Scroll;
  }
  export function Scrollable(args: Partial<ScrollableArgs>): Widget;

  interface SliderArgs extends CommonArgs {
    vertical: boolean;
    value: number;
    min: number;
    max: number;
    onChange: Command;
  }
  export function Slider(args: Partial<SliderArgs>): Widget;

  interface StackArgs extends CommonArgs {
    items: [string, Widget][];
    shown: string;
    transition:
    | 'none'
    | 'crossfade'
    | 'slide_right'
    | 'slide_left'
    | 'slide_up'
    | 'slide_down'
    | 'slide_left_right'
    | 'slide_up_down'
    | 'over_up'
    | 'over_down'
    | 'over_left'
    | 'over_right'
    | 'under_up'
    | 'under_down'
    | 'under_left'
    | 'under_right'
    | 'over_up_down'
    | 'over_down_up'
    | 'over_left_right'
    | 'over_right_left';
  }
  export function Stack(args: Partial<StackArgs>): Widget;

  interface MenuArgs extends CommonArgs {
    children: Widget[]; // TODO
    onPopup: Command;
    onMoveScroll: Command;
  }
  export function Menu(args: Partial<MenuArgs>): Widget;

  interface MenuItemArgs extends CommonArgs {
    child: Widget;
    onActivate: Command;
    onSelect: Command;
    onDeselect: Command;
  }
  export function MenuItem(args: Partial<MenuItemArgs>): Widget;
}

//#endregion
