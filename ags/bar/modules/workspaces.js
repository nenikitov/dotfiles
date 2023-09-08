import WindowManager from '../../services/window-manager.js';
import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

/** @type {WorkspacesConfig} */
const defaultArgs = {
  format: (workspace) => {
    return (
      (workspace.active ? '👉' : '') +
      (workspace.clients.length > 0 ? '=' : '') +
      workspace.display.icon +
      ' ' +
      workspace.display.name +
      ' (' +
      workspace.id +
      ')'
    );
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
          const monitorData = WindowManager.value.find((m) => monitor.id === m.id);
          if (!monitorData) {
            return;
          }

          box.children = monitorData.workspaces.map((w) =>
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
