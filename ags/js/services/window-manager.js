import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

import * as user from "../../user.js";

const SPECIAL_WORKSPACE_ID = -99;

const WindowManager = Variable(/** @type {Monitor[]} */ ([]), {});
export default WindowManager;

Hyprland.connect("changed", () => {
  WindowManager.value = getInfo(user.windowManager);
});

/**
 * @param {WindowManagerConfig} config
 * @returns {Monitor[]}
 */
function getInfo(config) {
  return Hyprland.monitors.map(parseMonitor(config));
}

/**
 * @param {Hyprland["clients"][0]} client
 * @return Client
 */
function parseClient(client) {
  /** @type {Client} */
  let result = {
    id: client.address,
    pid: client.pid,
    title: client.title,
    active: client.address === Hyprland.active.client.address,
    position: client.at,
    size: client.size,
    hidden: client.hidden,
    floating: client.floating,
    pinned: client.pinned,
    fullscreen: client.fullscreen,
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

/**
 * @param {number} workspacesPerMonitor
 * @param {Hyprland["clients"]} clientsAll
 * @param {WorkspaceInfo[]} workspacesDefaults
 * @param {Hyprland["monitors"][0]} monitor
 * @returns {(workspace: Hyprland["workspaces"][0]) => Workspace}
 */
function parseWorkspace(workspacesPerMonitor, clientsAll, workspacesDefaults, monitor) {
  return (workspace) => {
    const clients = clientsAll.filter((c) => c.workspace.id === workspace.id).map(parseClient);

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

/**
 * @param {WindowManagerConfig} config
 * @returns {(monitor: Hyprland["monitors"][0]) => Monitor}
 */
function parseMonitor(config) {
  return (monitor) => {
    const workspacesDefaults =
      config.defaultWorkspaces[monitor.name] ?? config.defaultWorkspaces["default"];

    /** @type {Workspace[]} */
    const workspaces = Hyprland.workspaces
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
