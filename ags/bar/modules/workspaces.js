import WindowManager from '../../services/window-manager.js';
import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

/** @type {WorkspacesConfig} */
const defaultArgs = {
  format: (workspace) => {
    const active = workspace.active ? '👉' : '';
    const clients = workspace.clients.length > 0 ? '=' : '';
    const display = workspace.display.icon || workspace.display.name;
    return active + clients + display;
  },
  hideEmpty: false,
  allMonitors: false,
};

/**
 * @param {WorkspacesArgs} args
 */
export function Workspaces({ monitor, ...args }) {
  const config = Object.assign({}, defaultArgs, args);

  return Box({
    className: 'workspaces',
    connections: [
      [
        WindowManager,
        (box) => {
          let monitors = config.allMonitors
            ? [WindowManager.value.find((m) => monitor.id === m.id)]
            : WindowManager.value;

          if (!monitors || monitors.length === 0) {
            return;
          }

          box.children = monitors.map((m) => {
            let workspaces = m.workspaces;
            if (config.hideEmpty) {
              workspaces = workspaces.filter((w) => w.clients.length !== 0 || w.active);
            }

            return Box({
              className: `workspace-group ${m.id}`,
              children: workspaces.map((w) =>
                Button({
                  className: [
                    'workspace',
                    w.index,
                    w.active ? 'active' : undefined,
                    w.clients.length > 0 ? 'occupied' : undefined,
                    String(w.index) === w.display.name ? 'misc' : undefined,
                  ]
                    .filter((e) => e !== undefined)
                    .join(' '),
                  child: Label({
                    label: config.format(w),
                  }),
                  tooltip_text: w.display.name,
                  onClicked: () => {
                    execAsync(`hyprctl dispatch workspace ${w.id}`);
                  },
                })
              ),
            });
          });
        },
      ],
    ],
  });
}
