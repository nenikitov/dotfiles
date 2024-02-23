import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import type { Hyprland as HyprlandType } from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

import * as options from "options";

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

const WindowManager = Variable<Monitor[]>([], {});
export default WindowManager;

Hyprland.connect("changed", () => {
  WindowManager.value = getInfo(options.windowManager);
});

function getInfo(config: WindowManagerConfig): Monitor[] {
  return Hyprland.monitors.map(parseMonitor(config));
}

function parseClient(client: HyprlandType["clients"][0]): Client {
  let result: Client = {
    id: client.address,
    pid: client.pid,
    title: client.title,
    active: client.address === Hyprland.active.client.address,
    position: client.at,
    size: client.size,
    hidden: client.hidden,
    mapped: client.mapped,
    floating: client.floating,
    pinned: client.pinned,
    fullscreen: client.fullscreen,
    class: client.class,
    initialClass: client.initialClass,
    focus: () => execAsync(`hyprctl dispatch focuswindow address:${client.address}`),
  };
  const queriedInfo =
    Applications.query(client.initialClass)[0] ?? Applications.query(client.initialTitle)[0];
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
  clientsAll: HyprlandType["clients"],
  workspacesDefaults: WorkspaceInfo[],
  monitor: HyprlandType["monitors"][0]
): (workspace: HyprlandType["workspaces"][0]) => Workspace {
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

function parseMonitor(
  config: WindowManagerConfig
): (monitor: HyprlandType["monitors"][0]) => Monitor {
  return (monitor) => {
    const workspacesDefaults =
      config.defaultWorkspaces[monitor.name] ?? config.defaultWorkspaces["default"];

    const workspaces: Workspace[] = Hyprland.workspaces
      .filter((w) => w.id != SPECIAL_WORKSPACE_ID && w.monitor === monitor.name)
      .map(
        parseWorkspace(config.workspacesPerMonitor, Hyprland.clients, workspacesDefaults, monitor)
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
      w.focus = () => execAsync(`hyprctl dispatch workspace ${w.id}`);
    }

    return {
      id: monitor.id,
      name: monitor.name,
      active: monitor.focused,
      position: [monitor.x, monitor.y],
      size: [monitor.width, monitor.height],
      scale: monitor.scale,
      workspaces: workspaces.sort((a, b) => a.id - b.id),
      focus: () => execAsync(`hyprctl dispatch focusmonitor ${monitor.id}`),
    };
  };
}
