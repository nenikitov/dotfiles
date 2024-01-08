import Gtk from "gi://Gtk";

import Widget from "resource:///com/github/Aylur/ags/widget.js";

import WindowManager from "../../../../services/window-manager.js";

/** @type {WorkspacesConfig} */
const defaultArgs = {
  format: (workspace) => {
    return workspace.display.icon || workspace.display.name;
  },
  formatTooltip: (workspace) => {
    return (
      workspace.index +
      " - " +
      (workspace.display.name || workspace.display.icon) +
      "\n" +
      workspace.clients.length +
      " opened"
    );
  },
  hideEmpty: false,
  allMonitors: false,
  maxDots: 3,
  vertical: false,
  special: "first",
};

/**
 * @param {WorkspacesArgs} args
 */
export function Workspaces({ monitor, ...args }) {
  const config = Object.assign({}, defaultArgs, args);

  return Widget.Box({
    class_name: "workspaces" + (args.class ? ` ${args.class}` : ""),
    vertical: config.vertical,
    connections: [
      [
        WindowManager,
        (box) => {
          let monitors = config.allMonitors
            ? WindowManager.value
            : WindowManager.value.filter((m) => monitor === m.id);

          if (!monitors || monitors.length === 0) {
            return;
          }

          box.children = monitors.map((m) => {
            let workspaces = m.workspaces;
            if (config.hideEmpty) {
              workspaces = workspaces.filter((w) => w.clients.length !== 0 || w.active);
            }

            return Widget.Box({
              class_name: `workspace-group ${m.id}`,
              vertical: config.vertical,
              children: workspaces.map((w) =>
                Widget.Button({
                  class_name: [
                    "workspace",
                    w.index,
                    w.active ? "active" : undefined,
                    w.clients.length > 0 ? "occupied" : undefined,
                    String(w.index) === w.display.name ? "misc" : undefined,
                  ]
                    .filter(Boolean)
                    .join(" "),
                  child: Widget.Overlay({
                    child: Widget.Label({
                      label: config.format(w),
                    }),
                    setup: (self) => {
                      const workspaceDotsGrid = new Gtk.Grid({
                        column_homogeneous: true,
                      });
                      for (const c of w.clients.slice(0, config.maxDots)) {
                        workspaceDotsGrid.add(
                          Widget.Box({
                            child: Widget.Icon({
                              class_name: ["client-dot", c.active ? "active" : undefined]
                                .filter(Boolean)
                                .join(" "),
                              size: 2,
                            }),
                            hpack: "center",
                          })
                        );
                      }
                      const workspaceDots = Widget.Box({
                        child: workspaceDotsGrid,
                        vpack: "start",
                        homogeneous: true,
                      });

                      const workpaceLine = Widget.Box({
                        child: Widget.Icon({
                          class_name: "workspace-line",
                          size: 2,
                        }),
                        vpack: "end",
                        homogeneous: true,
                      });

                      self.overlays = [workspaceDots, workpaceLine];
                    },
                  }),
                  tooltip_text: config.formatTooltip(w),
                  on_clicked: () => w.focus(),
                })
              ),
            });
          });
        },
      ],
    ],
  });
}
