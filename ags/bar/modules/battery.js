import { Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import BatteryService from 'resource:///com/github/Aylur/ags/service/battery.js';

/** @type {BatteryConfig} */
const defaultArgs = {
}

/**
 * @param {BatteryArgs} args
 */
export function Battery(args) {
  const config = Object.assign({}, defaultArgs, args);

  return Label({
    className: 'battery' + (args.class ? ` ${args.class}` : ''),
    connections: [
      [BatteryService, (self) => {
        self.label = String(BatteryService.timeRemaining)
      }]
    ]
  })
}
