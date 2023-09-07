import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

/**
 * @param {object} args
 * @param {import('resource:///com/github/Aylur/ags/service/hyprland.js').Monitor} args.monitor
 * @param {{ [monitor: string]: string[], default: string[] }} args.defaultWorkspaces
 * @param {number} args.workspacesPerMonitor
 */
function Workspaces({
  monitor,
  defaultWorkspaces = {
    default: ['1', '2', '3', '4'],
  },
  workspacesPerMonitor = 10,
}) {
  return Box({
    className: 'workspaces',
    connections: [
      [
        Hyprland,
        (box) => {
          const workspaces = (defaultWorkspaces[monitor.name] ?? defaultWorkspaces['default']).map(
            (w, i) => ({
              id: i + 1,
              name: w,
              active: false,
              hasWindows: false,
              hasFullscreen: false,
            })
          );

          const hyprlandWorkspaces = Hyprland.HyprctlGet('workspaces').filter(
            (w) => w.monitor === monitor.name
          );

          for (const w of hyprlandWorkspaces) {
            const id = (w.id % workspacesPerMonitor) - 1;
            const template = workspaces[id];
            workspaces[id] = {
              id: template?.id ?? id + 1,
              name:
                template?.name ??
                (w.name == String(w.id) ? String(w.id % workspacesPerMonitor) : w.name),
              active: false,
              hasWindows: w.windows > 0,
              hasFullscreen: w.hasfullscreen,
            };
          }

          const activeId =
            ((Hyprland.HyprctlGet('monitors').find((m) => m.id == monitor.id)?.activeWorkspace.id ??
              1) %
              workspacesPerMonitor) -
            1;
          workspaces[activeId].active = true;

          box.children = workspaces.map((w) =>
            Button({
              child: Label({ label: (w.active ? '▪' : '') + (w.hasWindows ? '_' : '') + w.name }),
              onClicked: () => {
                execAsync(`hyprctl dispatch split-workspace ${w.id}`);
              },
            })
          );
        },
      ],
    ],
  });
}
