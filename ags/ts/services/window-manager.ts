import { Service, Variable } from "prelude";
import {
  type Client as HyprlandClient,
  type Monitor as HyprlandMonitor,
  type Workspace as HyprlandWorkspace,
  type Hyprland,
} from "types/service/hyprland";
import { groupBy } from "utils/iterator";

export const WindowManager = Variable<WmMonitor[]>([]);

Service.Hyprland.connect("changed", (hyprland) => {
  WindowManager.value = hyprland.monitors.map(parseMonitor(hyprland));
});

function parseMonitor(hyprland: Hyprland): (monitor: HyprlandMonitor) => WmMonitor {
  return (monitor) => {
    return {
      id: monitor.id,
      name: monitor.name,
      description: monitor.description,
      dimensions: {
        x: monitor.width,
        y: monitor.height,
      },
      refreshRate: monitor.refreshRate,
      position: {
        x: monitor.x,
        y: monitor.y,
      },
      reserved: {
        top: monitor.reserved[0],
        bottom: monitor.reserved[1],
        left: monitor.reserved[2],
        right: monitor.reserved[3],
      },
      scale: monitor.scale,
      transform: monitor.transform,
      workspaces: {
        general: hyprland.workspaces
          .filter((w) => w.monitorID === monitor.id && w.id != monitor.specialWorkspace.id)
          .map(parseWorkspace(hyprland, monitor, false))
          .sort((a, b) => a.id - b.id),
        special:
          monitor.specialWorkspace.id != 0
            ? parseWorkspace(
                hyprland,
                monitor,
                true
              )(hyprland.getWorkspace(monitor.specialWorkspace.id)!)
            : undefined,
      },
      focused: monitor.focused,
      active: monitor.id === hyprland.active.monitor.id,
    };
  };
}

function parseWorkspace(
  hyprland: Hyprland,
  monitor: HyprlandMonitor,
  special: boolean
): (workspace: HyprlandWorkspace) => WmWorkspace {
  return (workspace) => {
    const { "": ungrouped, ...grouped } = groupBy(
      hyprland.clients.filter((c) => c.workspace.id === workspace.id && c.mapped),
      (c) => c.grouped.join(" ")
    );

    return {
      id: workspace.id,
      name: workspace.name,
      clients: [
        ...(ungrouped ?? []).map(parseClient(hyprland)),
        ...Object.values(grouped ?? []).map((g) => g.map(parseClient(hyprland))),
      ],
      focused: workspace.id === monitor.activeWorkspace.id,
      active: workspace.id === hyprland.active.workspace.id,
      special,
    };
  };
}

function parseClient(hyprland: Hyprland): (client: HyprlandClient) => WmClient {
  return (client) => {
    return {
      address: client.address,
      hidden: client.hidden,
      position: {
        x: client.at[0],
        y: client.at[1],
      },
      dimensions: {
        x: client.size[0],
        y: client.size[1],
      },
      floating: client.floating,
      pinned: client.pinned,
      fullscreen: client.fullscreen ? client.fullscreenMode : false,
      // TODO(nenikitov): Implement this
      urgent: false,
      class: {
        current: client.class,
        initial: client.initialClass,
      },
      title: {
        current: client.title,
        initial: client.initialTitle,
      },
      pid: client.pid,
      active: client.address === hyprland.active.client.address,
    };
  };
}

export interface WmWorkspaceName {
  icon: string;
  name: string;
}

export interface WmConfig {
  defaultWorkspaces: {
    default: WmWorkspaceName[];
    [monitorName: string]: WmWorkspaceName[];
  };
  workspacesPerMonitor: false | number;
}

export interface WmCoordinates {
  x: number;
  y: number;
}

export interface WmSides {
  top: number;
  bottom: number;
  left: number;
  right: number;
}

export enum WmTransform {
  None = 0,
  Rotate90 = 1,
  Rotate180 = 2,
  Rotate270 = 3,
  Flip = 4,
  FlipRotate90 = 5,
  FlipRotate180 = 6,
  FlipRotate270 = 7,
}

export interface WmMonitor {
  id: number;
  name: string;
  description: string;
  dimensions: WmCoordinates;
  refreshRate: number;
  position: WmCoordinates;
  reserved: WmSides;
  scale: number;
  transform: WmTransform;
  workspaces: {
    general: WmWorkspace[];
    special?: WmWorkspace;
  };
  focused: boolean;
  active: boolean;
}

export interface WmWorkspace {
  id: number;
  name: string;
  clients: (WmClient | WmClient[])[];
  focused: boolean;
  active: boolean;
  special: boolean;
}

export enum WmFullscreenMode {
  Fullscreen = 0,
  Maximize = 1,
  FakeFullscreen = 2,
}

export interface WmClient {
  address: string;
  hidden: boolean;
  position: WmCoordinates;
  dimensions: WmCoordinates;
  floating: boolean;
  pinned: boolean;
  fullscreen: false | WmFullscreenMode;
  urgent: boolean;
  class: {
    current: string;
    initial: string;
  };
  title: {
    current: string;
    initial: string;
  };
  pid: number;
  active: boolean;
}
