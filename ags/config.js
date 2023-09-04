#!/usr/bin/env gjs

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
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

const Workspaces = ({ monitor }) =>
  Box({
    className: 'workspaces',
    connections: [
      [
        Hyprland,
        (box) => {
          const workspaces = Hyprland.HyprctlGet('workspaces')
            .filter((w) => w.monitor === monitor.name)
            .map((w) => {
              w.id_monitor = w.id % config.WORKSPACES_PER_MONITOR;
              return w;
            });

          const workspaceNames = config.WORKSPACES[monitor.name] ?? config.WORKSPACES['default'];

          console.log(workspaceNames);

          const arr = Array.from({ length: 10 }, (_, i) => i + 1);
          box.children = arr.map((i) =>
            Button({
              onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
              child: Label({ label: `${i}` }),
              className: Hyprland.active.workspace.id == i ? 'focused' : '',
            })
          );
        },
      ],
    ],
  });

const Left = ({ monitor }) =>
  Box({
    children: [Workspaces({ monitor }), Label({ label: 'hello' })],
  });

const Bar = ({ monitor } = {}) =>
  Window({
    name: `bar${monitor?.id || ''}`,
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: Left({ monitor }),
  });

export default {
  windows: [Bar({ monitor: { id: 1, name: 'eDP-1' } })],
};
