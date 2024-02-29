import * as options from "options";
import { Service, Utils, Variable } from "prelude";
import {
  type Client as HyprlandClient,
  type Monitor as HyprlandMonitor,
  type Workspace as HyprlandWorkspace,
  type Hyprland,
} from "types/service/hyprland";
import { groupBy } from "utils/iterator";

export const WindowManager = Variable<WmMonitor[]>([]);

Service.Hyprland.connect("changed", (hyprland) => {
  WindowManager.value = hyprland.monitors.map(parseMonitor(hyprland, options.windowManager));
});

function parseMonitor(
  hyprland: Hyprland,
  config: WmConfig
): (monitor: HyprlandMonitor) => WmMonitor {
  return (monitor) => {
    const workspaceNames = config.workspaceNames[monitor.name] ?? config.workspaceNames["default"];

    const { general, special } = groupBy(
      hyprland.workspaces.filter((w) => w.monitorID === monitor.id),
      (w) => (w.id < 0 ? "special" : "general")
    );

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
        general: completeWorkspaces(
          hyprland,
          config,
          workspaceNames.general,
          general.map(parseWorkspace(hyprland, monitor, false)).sort((a, b) => a.id - b.id)
        ),
        special: special?.length
          ? completeSpecialWorkspace(
              workspaceNames.special,
              parseWorkspace(hyprland, monitor, true)(special[0])
            )
          : undefined,
      },
      focused: monitor.focused,
      active: monitor.id === hyprland.active.monitor.id,
      focus: () => {
        hyprland.messageAsync(`dispatch focusmonitor ${monitor.id}`);
      },
    };
  };
}

function parseWorkspace(
  hyprland: Hyprland,
  monitor: HyprlandMonitor,
  special: boolean
): (workspace: HyprlandWorkspace) => Omit<WmWorkspace, "display"> & { name?: string } {
  return (workspace) => {
    const { "": ungrouped, ...grouped } = groupBy(
      hyprland.clients.filter((c) => c.workspace.id === workspace.id && c.mapped),
      (c) => c.grouped.join(" ")
    );

    return {
      id: workspace.id,
      name: workspace.name !== workspace.id.toString() ? workspace.name : undefined,
      clients: [
        ...(ungrouped ?? []).map(parseClient(hyprland)).sort(sortClients),
        ...Object.values(grouped ?? []).map((g) => g.map(parseClient(hyprland)).sort(sortClients)),
      ],
      focused: workspace.id === monitor.activeWorkspace.id,
      active: workspace.id === hyprland.active.workspace.id,
      special,
      focus: () => {
        hyprland.messageAsync(`dispatch workspace ${workspace.id}`);
      },
    };
  };
}

function getWorkspaceIdAtMonitor(id: number, workspacesPerMonitor: number): number {
  return workspacesPerMonitor !== 0 ? ((id - 1) % workspacesPerMonitor) + 1 : id;
}

function getWorkspaceStartAtMonitor(id: number, workspacesPerMonitor: number): number {
  return workspacesPerMonitor !== 0
    ? Math.floor((id - 1) / workspacesPerMonitor) * workspacesPerMonitor + 1
    : 0;
}

function completeWorkspaces(
  hyprland: Hyprland,
  config: WmConfig,
  workspaceNames: WmWorkspaceName[],
  workspaces: (Omit<WmWorkspace, "display"> & { name?: string })[]
): WmWorkspace[] {
  const workspacesFull: WmWorkspace[] = workspaces.map((w) =>
    completeWorkspace(
      config,
      workspaceNames[getWorkspaceIdAtMonitor(w.id, config.workspacesPerMonitor) - 1],
      w
    )
  );

  let completeAmount = 0;
  if (typeof config.completeWorkspaces === "number") {
    completeAmount = config.completeWorkspaces;
  } else if (config.completeWorkspaces === "name-only") {
    completeAmount = workspaceNames.length;
  } else if (config.completeWorkspaces === "until-largest") {
    const index = workspacesFull[workspacesFull.length - 1].display.index;
    completeAmount = index === "special" ? 0 : index;
  }

  for (let i = 1; i <= completeAmount; i++) {
    const index = workspacesFull.findIndex((w) => w.display.index === i);
    if (index === -1) {
      const id =
        getWorkspaceStartAtMonitor(workspacesFull[0].id, config.workspacesPerMonitor) + i - 1;

      workspacesFull.push({
        id,
        clients: [],
        focused: false,
        active: false,
        special: false,
        display: {
          index: i,
          ...(workspaceNames[i - 1] ?? { icon: "", name: id.toString() }),
        },
        focus: () => {
          hyprland.messageAsync(`dispatch workspace ${id}`);
        },
      });
    }
  }

  return workspacesFull.sort((a, b) => a.id - b.id);
}

function completeWorkspace(
  config: WmConfig,
  workspaceName: WmWorkspaceName | undefined,
  workspace: Omit<WmWorkspace, "display"> & { name?: string }
) {
  const completed = {
    ...workspace,
    display: {
      index: ((workspace.id - 1) % config.workspacesPerMonitor) + 1,
      ...workspaceName,
      ...(workspace.name ? { name: workspace.name } : {}),
    },
  };

  return completed;
}

function completeSpecialWorkspace(
  workspaceName: WmWorkspaceName,
  workspace: Omit<WmWorkspace, "display">
): WmWorkspace {
  return {
    ...workspace,
    display: {
      index: "special",
      ...workspaceName,
    },
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
      // TODO(nenikitov): There is an issue with Hyprland service and `hyprland.active.client` is not updated properly on window close
      // This is a hack that re-requests active client id. Replace with `hyprland.active.client.address` if it's gets fixed.
      // active: client.address === hyprland.active.client.address
      active:
        client.address ===
        (JSON.parse(hyprland.message("j/activewindow")) as HyprlandClient).address,
      focus: () => {
        hyprland.messageAsync(`dispatch focus address:${client.address}`);
      },
    };
  };
}

function sortClients(a: WmClient, b: WmClient) {
  return (
    Number(b.floating) - Number(a.floating) ||
    a.position.x - b.position.x ||
    a.position.y - b.position.y
  );
}

export interface WmWorkspaceName {
  icon: string;
  name: string;
}

export interface WmAllWorkpaceNames {
  general: WmWorkspaceName[];
  special: WmWorkspaceName;
}

export interface WmConfig {
  workspaceNames: {
    default: WmAllWorkpaceNames;
    [monitorName: string]: WmAllWorkpaceNames;
  };
  completeWorkspaces: false | "name-only" | "until-largest" | number;
  workspacesPerMonitor: number;
}

export interface WmFocusable {
  focus: () => void;
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

export interface WmMonitor extends WmFocusable {
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

export interface WmWorkspace extends WmFocusable {
  id: number;
  clients: (WmClient | WmClient[])[];
  focused: boolean;
  active: boolean;
  special: boolean;
  display: Partial<WmWorkspaceName> & {
    index: number | "special";
  };
}

export enum WmFullscreenMode {
  Fullscreen = 0,
  Maximize = 1,
  FakeFullscreen = 2,
}

export interface WmClient extends WmFocusable {
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
