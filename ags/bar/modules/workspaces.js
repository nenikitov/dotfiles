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
          let workspaces = config.hideEmpty
            ? WindowManager.value.find((m) => monitor.id === m.id)?.workspaces
            : WindowManager.value.map((m) => m.workspaces).flat();

          if (!workspaces) {
            return;
          }

          if (config.hideEmpty) {
            workspaces = workspaces.filter((w) => w.clients.length !== 0 || w.active);
          }

          box.children = workspaces.map((w) =>
            Button({
              child: Label({
                label: config.format(w),
              }),
              onClicked: () => {
                execAsync(`hyprctl dispatch workspace ${w.id}`);
              },
            })
          );
        },
      ],
    ],
  });
}
