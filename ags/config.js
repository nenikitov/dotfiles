#!/usr/bin/env gjs

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import {
  Box,
  Button,
  Stack,
  Label,
  Icon,
  CenterBox,
  Window,
  Slider,
  ProgressBar,
} from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import * as config from './user.js';

/**
 * @param {object} args
 * @param {import('resource:///com/github/Aylur/ags/service/hyprland.js').Monitor} args.monitor
 */
function Workspaces({ monitor }) {
  return Box({
    className: 'workspaces',
    connections: [
      [
        Hyprland,
        (box) => {
          const workspaces = (config.WORKSPACES[monitor.name] ?? config.WORKSPACES['default']).map(
            (w) => ({ name: w, active: false, hasWindows: false, hasFullscreen: false })
          );

          const hyprlandWorkspaces = Hyprland.HyprctlGet('workspaces').filter(
            (w) => w.monitor === monitor.name
          );

          for (const w of hyprlandWorkspaces) {
            const id = w.id % config.WORKSPACES_PER_MONITOR - 1;
            const template = workspaces[id];
            workspaces[id] = {
              name: template.name ?? w.name,
              active: false,
              hasWindows: w.windows > 0,
              hasFullscreen: w.hasfullscreen
            }
          }

          const activeId = Hyprland.HyprctlGet('monitors').find(m => m.id == monitor.id)?.activeWorkspace.id ?? 0;
          workspaces[activeId - 1].active = true;

          box.children = workspaces.map((w) =>
            Button({
              child: Label({ label: (w.active ? '_' : '') + (w.hasWindows ? '.' : '') + w.name }),
            })
          );
        },
      ],
    ],
  });
}

const Left = ({ monitor }) =>
  Box({
    children: [Workspaces({ monitor }), Label({ label: 'hello' })],
  });

/**
 * @param {object} args
 * @param {import('resource:///com/github/Aylur/ags/service/hyprland.js').Monitor} args.monitor
 */
function Bar({ monitor }) {
  return Window({
    name: `bar${monitor?.id || ''}`,
    className: 'bar',
    monitor: monitor.id,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: Left({ monitor }),
  });
}

export default {
  windows: [...Hyprland.HyprctlGet('monitors').map((monitor) => Bar({ monitor }))],
};
