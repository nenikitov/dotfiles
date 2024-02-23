import * as options from "options";
import { Service, Utils, Variable } from "prelude";
import {
  type Client as HyprlandClient,
  type Monitor as HyprlandMonitor,
  type Workspace as HyprlandWorkspace,
} from "types/service/hyprland";

interface Focusable {
  focus: () => void;
}

interface ClientDesktopInfo {
  name: string | null;
  description: string | null;
  icon: string;
}

interface Client extends Focusable {
  id: string;
  pid: number;
  title: string;
  active: boolean;
  position: [number, number];
  size: [number, number];
  hidden: boolean;
  mapped: boolean;
  floating: boolean;
  pinned: boolean;
  fullscreen: boolean;
  desktopInfo?: ClientDesktopInfo;
  class: string;
  initialClass: string;
}

interface WorkspaceInfo {
  name: string;
  icon: string;
}

export interface Workspace extends Focusable {
  id: number;
  index: number;
  display: WorkspaceInfo;
  active: boolean;
  clients: Client[];
}

interface Monitor extends Focusable {
  id: number;
  name: string;
  active: boolean;
  position: [number, number];
  size: [number, number];
  scale: number;
  workspaces: Workspace[];
}

export interface WindowManagerConfig {
  defaultWorkspaces: {
    [monitorName: string]: WorkspaceInfo[];
    default: WorkspaceInfo[];
  };
  workspacesPerMonitor: number;
}

const SPECIAL_WORKSPACE_ID = -99;

export const WindowManager = Variable<Monitor[]>([], {});

Service.Hyprland.connect("changed", () => {
  WindowManager.value = getInfo(options.windowManager);
});

function getInfo(config: WindowManagerConfig): Monitor[] {
  return Service.Hyprland.monitors.map(parseMonitor(config));
}

function parseClient(client: HyprlandClient): Client {
  const result: Client = {
    id: client.address,
    pid: client.pid,
    title: client.title,
    active: client.address === Service.Hyprland.active.client.address,
    position: client.at,
    size: client.size,
    hidden: client.hidden,
    mapped: client.mapped,
    floating: client.floating,
    pinned: client.pinned,
    fullscreen: client.fullscreen,
    class: client.class,
    initialClass: client.initialClass,
    focus: () => Utils.execAsync(`hyprctl dispatch focuswindow address:${client.address}`),
  };
  const queriedInfo =
    Service.Applications.query(client.initialClass)[0] ??
    Service.Applications.query(client.initialTitle)[0];
  if (queriedInfo) {
    result.desktopInfo = {
      name: queriedInfo.name,
      description: queriedInfo.description,
      icon: queriedInfo.icon_name || "",
    };
  }
  return result;
}

function parseWorkspace(
  workspacesPerMonitor: number,
  clientsAll: HyprlandClient[],
  workspacesDefaults: WorkspaceInfo[],
  monitor: HyprlandMonitor
): (workspace: HyprlandWorkspace) => Workspace {
  return (workspace) => {
    const clients = clientsAll
      .filter((c) => c.workspace.id === workspace.id)
      .filter((c) => c.mapped && !c.hidden)
      .map(parseClient);

    const special = workspace.id === SPECIAL_WORKSPACE_ID;
    const index = special ? workspace.id : ((workspace.id - 1) % workspacesPerMonitor) + 1;
    const defaults = special ? { icon: "", name: "" } : workspacesDefaults[index - 1];

    return {
      id: workspace.id,
      index,
      display: {
        icon: defaults?.icon ?? "",
        name:
          workspace.name === String(workspace.id)
            ? defaults?.name ?? workspace.name
            : workspace.name,
      },
      active: workspace.id === monitor.activeWorkspace.id,
      clients: clients,
      focus: () => {},
    };
  };
}

function parseMonitor(config: WindowManagerConfig): (monitor: HyprlandMonitor) => Monitor {
  return (monitor) => {
    const workspacesDefaults =
      config.defaultWorkspaces[monitor.name] ?? config.defaultWorkspaces["default"];

    const workspaces: Workspace[] = Service.Hyprland.workspaces
      .filter((w) => w.id != SPECIAL_WORKSPACE_ID && w.monitor === monitor.name)
      .map(
        parseWorkspace(
          config.workspacesPerMonitor,
          Service.Hyprland.clients,
          workspacesDefaults,
          monitor
        )
      );

    for (const [index, defaults] of workspacesDefaults.entries()) {
      const id = monitor.id * config.workspacesPerMonitor + index + 1;
      if (!workspaces.some((w) => w.id === id)) {
        workspaces.push({
          id,
          index: index + 1,
          display: defaults,
          active: false,
          clients: [],
          focus: () => {},
        });
      }
    }

    for (const w of workspaces) {
      w.focus = () => Utils.execAsync(`hyprctl dispatch workspace ${w.id}`);
    }

    return {
      id: monitor.id,
      name: monitor.name,
      active: monitor.focused,
      position: [monitor.x, monitor.y],
      size: [monitor.width, monitor.height],
      scale: monitor.scale,
      workspaces: workspaces.sort((a, b) => a.id - b.id),
      focus: () => Utils.execAsync(`hyprctl dispatch focusmonitor ${monitor.id}`),
    };
  };
}
