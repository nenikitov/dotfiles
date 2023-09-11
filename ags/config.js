#!/usr/bin/env gjs

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { Box, CenterBox, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import { Workspaces } from './bar/modules/workspaces.js';
import { Clock } from './bar/modules/clock.js';

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
    children: [
      Clock({
        format: '%H:%M:%S\n%a %Y-%m-%d',
        formatTooltip: '%H:%M:%S\n%A\n%B %d, %Y\n%Z (%:z)',
      }),
    ],
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
