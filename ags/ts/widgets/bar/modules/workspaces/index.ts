import { Gtk, Widget } from "prelude";
import { WindowManager, type WmWorkspace } from "services/window-manager";
import { groupBy } from "utils/iterator";
import { Module } from "../module";

interface WorkspacesConfig {
  format: (workspace: WmWorkspace) => string;
  formatTooltip: (workspace: WmWorkspace) => string;
  allMonitors: boolean;
  special: "hide" | "first" | "last";
  hideEmpty: boolean;
}

const configDefault: WorkspacesConfig = {
  format: (workspace: WmWorkspace): string => {
    return workspace.display.icon ?? workspace.display.name ?? workspace.display.index.toString();
  },
  formatTooltip: (workspace: WmWorkspace): string => {
    return [
      (workspace.display.name ? `${workspace.display.index} - ` : "") +
        (workspace.display.name ?? workspace.display.index),
      workspace.clients.length > 0 ? `${workspace.clients.length} opened` : undefined,
    ]
      .filter(Boolean)
      .join("\n");
  },
  allMonitors: false,
  special: "first",
  hideEmpty: false,
};

export function Workspaces(
  configPartial: Partial<WorkspacesConfig>
): (monitor: number) => Gtk.Widget {
  return (monitor) => {
    const config = Object.assign({}, configDefault, configPartial);

    return Widget.Box({
      className: "workspaces",
      children: WindowManager.bind().as((m) => {
        const displayedMonitors = config.allMonitors ? m : [m.find((m) => m.id === monitor)!];

        return displayedMonitors.map((m) => {
          let workspaces = (m ?? {}).workspaces?.general ?? [];
          if (config.hideEmpty) {
            workspaces = workspaces.filter((w) => w.clients.length !== 0 || w.active);
          }
          if (config.special !== "hide" && m.workspaces.special) {
            workspaces.unshift(m.workspaces.special);
          }

          return Widget.Box({
            classNames: ["monitor", `monitor-${m.name}`],
            children: workspaces.map(Workspace(config)),
          });
        });
      }),
    });
  };
}

function Workspace(config: WorkspacesConfig): (workspace: WmWorkspace) => Gtk.Widget {
  return (workspace) => {
    return Module({
      className: ["workspace", `workspace-${workspace.display.name}`],
      child: Widget.Label({
        label: config.format(workspace),
      }),
      tooltip: config.formatTooltip(workspace),
      onClicked: () => {
        workspace.focus();
      },
    });
  };
}

// import { Gtk, Widget } from "prelude";
// import { WindowManager, type Workspace } from "services/window-manager";
// import { groupBy } from "utils/iterator";
//
// import { ModuleConfig } from "../module";
//
// interface WorkspacesConfig extends ModuleConfig {
//   format: (workspace: Workspace) => string;
//   formatTooltip: (workspace: Workspace) => string;
//   hideEmpty: boolean;
//   allMonitors: boolean;
//   maxDots: 3;
//   special: "hide" | "first" | "last";
// }
//
// const configDefault: WorkspacesConfig = {
//   format: (workspace) => {
//     return workspace.display.icon || workspace.display.name;
//   },
//   formatTooltip: (workspace) => {
//     return (
//       workspace.index +
//       " - " +
//       (workspace.display.name || workspace.display.icon) +
//       "\n" +
//       workspace.clients.length +
//       " opened"
//     );
//   },
//   hideEmpty: false,
//   allMonitors: false,
//   maxDots: 3,
//   vertical: false,
//   special: "first",
// };
//
// export function Workspaces(config: Partial<WorkspacesConfig>): (monitor: number) => Gtk.Widget {
//   return (monitor) => {
//     const configFull = Object.assign({}, configDefault, config);
//
//     return Widget.Box({
//       class_name: "workspaces" + (configFull.class ? ` ${configFull.class}` : ""),
//       vertical: configFull.vertical,
//       // TODO(nenikitov): `connections` is deprecated
//       connections: [
//         [
//           WindowManager,
//           (box) => {
//             const monitors = configFull.allMonitors
//               ? WindowManager.value
//               : WindowManager.value.filter((m) => monitor === m.id);
//
//             if (!monitors || monitors.length === 0) {
//               return;
//             }
//
//             box.children = monitors.map((m) => {
//               let workspaces = m.workspaces;
//               if (configFull.hideEmpty) {
//                 workspaces = workspaces.filter((w) => w.clients.length !== 0 || w.active);
//               }
//
//               return Widget.Box({
//                 class_name: `workspace-group ${m.id}`,
//                 vertical: configFull.vertical,
//                 children: workspaces.map((w) =>
//                   Widget.Button({
//                     class_name: [
//                       "workspace",
//                       w.index,
//                       w.active ? "active" : undefined,
//                       w.clients.length > 0 ? "occupied" : undefined,
//                       String(w.index) === w.display.name ? "misc" : undefined,
//                     ]
//                       .filter(Boolean)
//                       .join(" "),
//                     child: Widget.Overlay({
//                       child: Widget.Label({
//                         label: configFull.format(w),
//                       }),
//                       setup: (self) => {
//                         const workspaceDotsGrid = new Gtk.Grid({
//                           column_homogeneous: true,
//                         });
//                         const clients = groupBy(w.clients, (e) => e.initialClass);
//                         for (const c of Object.values(clients).slice(0, configFull.maxDots)) {
//                           workspaceDotsGrid.add(
//                             Widget.Box({
//                               child: Widget.Icon({
//                                 class_name: [
//                                   "client-dot",
//                                   c.some((c) => c.active) ? "active" : undefined,
//                                 ]
//                                   .filter(Boolean)
//                                   .join(" "),
//                                 size: 2,
//                               }),
//                               hpack: "center",
//                             })
//                           );
//                         }
//                         const workspaceDots = Widget.Box({
//                           child: workspaceDotsGrid,
//                           vpack: "start",
//                           homogeneous: true,
//                         });
//
//                         const workpaceLine = Widget.Box({
//                           child: Widget.Icon({
//                             class_name: "workspace-line",
//                             size: 2,
//                           }),
//                           vpack: "end",
//                           homogeneous: true,
//                         });
//
//                         self.overlays = [workspaceDots, workpaceLine];
//                       },
//                     }),
//                     tooltip_text: configFull.formatTooltip(w),
//                     on_clicked: () => w.focus(),
//                   })
//                 ),
//               });
//             });
//           },
//         ],
//       ],
//     });
//   };
// }
