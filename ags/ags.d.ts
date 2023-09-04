interface Service { }

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

  export interface Active {
    client: ClientShort;
    monitor: string;
    workspace: WorkspaceShort;
  }

  export interface LayerClient {
    address: string;
    x: number;
    y: number;
    w: number;
    h: number;
    namespace: string;
  }

  interface Layer {
    levels: Record<'0' | '1' | '2' | '3', LayerClient[]>;
  }

  interface Device {
    address: string;
    name: string;
  }

  interface Mouse extends Device {
    defaultSpeed: number;
  }

  interface Keyboard extends Device {
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
  }

  interface Devices {
    mice: Mouse[];
    keyboards: Keyboard[];
    tablets: Device[]; // TODO
    touch: Device[];
    switches: Device[];
  }

  interface Bind {
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

  interface Version {
    branch: string;
    commit: string;
    dirty: boolean;
    commit_message: string;
    tag: string;
    flags: string[];
  }

  interface Position {
    x: number;
    y: number;
  }

  interface Instance {
    instance: string;
    time: number;
    pid: number;
    wl_socket: string;
  }

  interface Hyprland extends Service {
    get active(): Active;
    get monitors(): Map<number, Monitor>;
    get workspaces(): Map<number, Workspace>;
    get clients(): Map<string, Client>;

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
    HyprctlGet(cmd: 'cursorpos'): Position;
    HyprctlGet(cmd: 'globalshortcuts'): object[]; // TODO
    HyprctlGet(cmd: 'instances'): Instance[]; // TODO
  }

  const hyprland: Hyprland;
  export default hyprland;
}
