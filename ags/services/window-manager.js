import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import * as user from '../user.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const WORKSPACES_PER_MONITOR = 10;

const WindowManager = Variable(/** @type {Monitor[]} */ ([]), {});

Hyprland.instance.connect('changed', () => {
  WindowManager.value = getInfo(user.windowManager);
});

/**
 * @param {WindowManagerConfig} config
 * @returns {Monitor[]}
 */
function getInfo(config) {
  const monitorsAll = Array.from(Hyprland.monitors.values());
  const workspacesAll = Array.from(Hyprland.workspaces.values());
  const clientsAll = Array.from(Hyprland.clients.values());
  const clientActive = Hyprland.active.client;

  return monitorsAll.map((m) => {
    const workspacesDefaults =
      config.defaultWorkspaces[m.name] ?? config.defaultWorkspaces['default'];

    /** @type {Workspace[]} */
    const workspaces = workspacesAll
      .filter((w) => w.monitor === m.name)
      .map((w) => {
        /** @type {Client[]} */
        const clients = clientsAll
          .filter((c) => c.workspace.id === w.id)
          .map((c) => {
            /** @type {Client} */
            let client = {
              id: c.address,
              pid: c.pid,
              title: c.title,
              active: c.address === clientActive.address,
              position: c.at,
              size: c.size,
              hidden: c.hidden,
              floating: c.floating,
              pinned: c.pinned,
              fullscreen: c.fullscreen,
              focus: () => execAsync(`hyprctl dispatch focuswindow address:${c.address}`),
            };
            const queriedInfo =
              Applications.query(c.initialClass)[0] ?? Applications.query(c.initialTitle)[0];
            if (queriedInfo) {
              client.desktopInfo = {
                name: queriedInfo.name,
                description: queriedInfo.description,
                icon: queriedInfo.iconName,
              };
            }
            return client;
          });

        const index = ((w.id - 1) % WORKSPACES_PER_MONITOR) + 1;
        const defaults = workspacesDefaults[index - 1];

        return {
          id: w.id,
          index,
          display: {
            icon: defaults?.icon ?? '',
            name: w.name === String(w.id) ? defaults?.name ?? w.name : w.name,
          },
          active: w.id === m.activeWorkspace.id,
          clients: clients,
          focus: () => {},
        };
      });

    for (const [index, defaults] of workspacesDefaults.entries()) {
      const id = m.id * config.workspacesPerMonitor + index + 1;
      if (!workspaces.some((w) => w.id === id)) {
        workspaces.push({
          id,
          index: index + 1,
          display: defaults,
          active: false,
          clients: [],
          focus: () => {},
        });
      }
    }

    for (const w of workspaces) {
      w.focus = () => execAsync(`hyprctl dispatch workspace ${w.id}`);
    }

    return {
      id: m.id,
      name: m.name,
      active: m.focused,
      position: [m.x, m.y],
      size: [m.width, m.height],
      scale: m.scale,
      workspaces: workspaces.sort((a, b) => a.id - b.id),
      focus: () => execAsync(`hyprctl dispatch focusmonitor ${m.id}`),
    };
  });
}

export default WindowManager;
