import { Gtk, Widget } from "prelude";
import { type WmClient, type WmWorkspace } from "services/window-manager";
import { treatClassNames } from "utils/widget";

import { WorkspacesConfig } from ".";
import { Module } from "../module";

export function Workspace(config: WorkspacesConfig): (workspace: WmWorkspace) => Gtk.Widget {
  return (workspace) => {
    return Module({
      className: [
        "workspace",
        `workspace-${workspace.display.name}`,
        workspace.active ? "active" : undefined,
        workspace.focused ? "focused" : undefined,
        workspace.clients.some((c) => (Array.isArray(c) ? c : [c]).some((c) => !c.hidden))
          ? "occupied"
          : undefined,
      ],
      child: Widget.Overlay({
        child: WorkspaceName(config)(workspace),
        overlays: [
          Widget.Box({
            child: WorkspaceActiveLine(config)(workspace),
            vpack: "end",
            homogeneous: true,
          }),
          Widget.Box({
            child: WorkspaceDots(config)(workspace),
            vpack: "start",
            homogeneous: true,
          }),
        ],
      }),
      tooltip: config.formatTooltip(workspace),
      onClicked: () => {
        workspace.focus();
      },
    });
  };
}

function WorkspaceActiveLine(config: WorkspacesConfig): (workspace: WmWorkspace) => Gtk.Widget {
  return (workspace) => {
    return Widget.Icon({
      className: "workspace-line",
      size: 2,
    });
  };
}

function WorkspaceName(config: WorkspacesConfig): (workspace: WmWorkspace) => Gtk.Widget {
  return (workspace) => {
    return Widget.Label({
      label: config.format(workspace),
    });
  };
}

function WorkspaceDots(config: WorkspacesConfig): (workspace: WmWorkspace) => Gtk.Widget {
  return (workspace) => {
    const clients = sliceClients(
      config,
      workspace.clients.filter((c) => (Array.isArray(c) ? c.some((c) => !c.hidden) : !c.hidden))
    );

    return Widget.Box({
      children: clients.map(WorkspaceDot(config)),
      homogeneous: true,
    });
  };
}

function WorkspaceDot(config: WorkspacesConfig): (client: WmClient | WmClient[]) => Gtk.Widget {
  return (client) => {
    return Widget.Box({
      child: Widget.Icon({
        classNames: treatClassNames(["client-dot", isActive(client) ? "active" : undefined]),
        size: 2,
        hexpand: false,
      }),
      hpack: "center",
    });
  };
}

function isActive(client: WmClient | WmClient[]): boolean {
  return Array.isArray(client) ? client.some((c) => c.active) : client.active;
}
function sliceClients(
  config: WorkspacesConfig,
  clients: (WmClient | WmClient[])[]
): (WmClient | WmClient[])[] {
  if (config.maxDots == 0) {
    return [];
  }

  const active = clients.findIndex(isActive);

  if (active != -1) {
    if (active < config.maxDots) {
      return clients.slice(0, config.maxDots);
    } else {
      return clients.slice(0, config.maxDots - 1).concat(clients[active]);
    }
  } else {
    return clients.slice(0, config.maxDots);
  }
}
