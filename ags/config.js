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
import WindowManager from './services/window-manager.js';
import { Workspaces } from './bar/modules/workspaces.js';

const SECOND = 1000;

/**
 * @param {object} args
 * @param {string} [args.format]
 * @param {number} [args.interval]
 * @param {import('resource:///com/github/Aylur/ags/widget.js').Justification} [args.justification]
 */
function Clock({ interval = SECOND }) {
  return Label({
    connections: [
      [
        interval,
        (label) => {
          label.label = DateTime.new_now_local().format(config.CLOCK_FORMAT);
        },
      ],
    ],
    justification: 'center',
  });
}

/**
 * @param {object} args
 * @param {import('resource:///com/github/Aylur/ags/service/hyprland.js').Monitor} args.monitor
 */
function Left({ monitor }) {
  return Box({
    children: [Workspaces({ monitor })],
  });
}

function Right() {
  return Box({
    children: [Clock({})],
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
