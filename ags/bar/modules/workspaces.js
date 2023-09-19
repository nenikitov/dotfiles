import WindowManager from '../../services/window-manager.js';
import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';

/** @type {WorkspacesConfig} */
const defaultArgs = {
  format: (workspace) => {
    return workspace.display.icon || workspace.display.name;
  },
  formatTooltip: (workspace) => {
    return (
      workspace.index +
      ' - ' +
      (workspace.display.name || workspace.display.icon) +
      '\n' +
      workspace.clients.length +
      ' opened'
    );
  },
  hideEmpty: false,
  allMonitors: false,
  vertical: false,
};

/**
 * @param {WorkspacesArgs} args
 */
export function Workspaces({ monitor, ...args }) {
  const config = Object.assign({}, defaultArgs, args);

  return Box({
    className: 'workspaces' + (args.class ? ` ${args.class}` : ''),
    vertical: config.vertical,
    connections: [
      [
        WindowManager,
        (box) => {
          let monitors = config.allMonitors
            ? WindowManager.value
            : WindowManager.value.filter((m) => monitor.id === m.id);

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
              vertical: config.vertical,
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
                  tooltip_text: config.formatTooltip(w),
                  onClicked: () => w.focus(),
                })
              ),
            });
          });
        },
      ],
    ],
  });
}
