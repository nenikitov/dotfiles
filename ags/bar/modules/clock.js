const { DateTime } = imports.gi.GLib;

import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import { seconds } from '../../utils/time.js';

/** @type {ClockConfig} */
const defaultArgs = {
  format: '%X',
  formatTooltip: '%c',
  interval: seconds(1),
  vertical: false,
  justification: 'center',
};

/**
 * @param {ClockArgs} args
 */
export function Clock(args) {
  const config = Object.assign({}, defaultArgs, args);

  return Label({
    className: 'clock' + (args.class ? ` ${args.class}` : ''),
    justification: config.justification,
    angle: config.vertical ? 90 : 0,
    connections: [
      [
        config.interval,
        (label) => {
          const date = DateTime.new_now_local();
          label.label = date.format(config.format);
          label.tooltip_text = date.format(config.formatTooltip);
        },
      ],
    ],
  });
}