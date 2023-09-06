#!/usr/bin/env gjs

const { DateTime } = imports.gi.GLib;

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
            const id = (w.id % config.WORKSPACES_PER_MONITOR) - 1;
            const template = workspaces[id];
            workspaces[id] = {
              id: template?.id ?? id + 1,
              name:
                template?.name ??
                (w.name == String(w.id) ? String(w.id % config.WORKSPACES_PER_MONITOR) : w.name),
              active: false,
              hasWindows: w.windows > 0,
              hasFullscreen: w.hasfullscreen,
            };
          }

          const activeId =
            ((Hyprland.HyprctlGet('monitors').find((m) => m.id == monitor.id)?.activeWorkspace.id ??
              1) %
              config.WORKSPACES_PER_MONITOR) -
            1;
          workspaces[activeId].active = true;

          box.children = workspaces.map((w) =>
            Button({
              child: Label({ label: (w.active ? '_' : '') + (w.hasWindows ? '.' : '') + w.name }),
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

const SECOND = 1000;
/**
 * @param {object} args
 * @param {string} [args.format]
 * @param {number} [args.interval]
 * @param {import('resource:///com/github/Aylur/ags/widget.js').Justification} [args.justification]
 */
function Clock({ format = '%A %Y-%m-%d %H:%M:%S', interval = SECOND }) {
  return Label({
    connections: [
      [
        interval,
        (label) => {
          label.label = DateTime.new_now_local().format(format);
        },
      ],
    ],
    justification: 'center',
  });
}

function Left({ monitor }) {
  return Box({
    children: [Workspaces({ monitor })],
  });
}

function Right() {
  return Box({
    children: [Clock({ format: '%H:%M:%S\n%a %Y-%m-%d' })],
    halign: 'end',
  });
}

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
    child: CenterBox({
      startWidget: Left({ monitor }),
      endWidget: Right(),
    }),
  });
}

export default {
  style: App.configDir + '/style.css',
  windows: [...Hyprland.HyprctlGet('monitors').map((monitor) => Bar({ monitor }))],
};
