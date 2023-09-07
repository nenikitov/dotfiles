import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';

/*
connect(
  Hyprland.instance,
  {
    connect: () => {}
  },
  () => {
    console.log('here');
  }
)
*/

/**
 * @returns {Monitor[]}
 */
export function getMonitors() {
  const monitors = Hyprland.HyprctlGet('monitors');
  const workspaces = Hyprland.HyprctlGet('workspaces');
  const clients = Hyprland.HyprctlGet('clients');
  const activeClient = Hyprland.HyprctlGet('activewindow');

  return monitors.map((m) => {
    /** @type {Workspace[]} */
    const monitorWorkspaces = workspaces
      .filter((w) => w.monitor === m.name)
      .map((w) => {
        /** @type {Client[]} */
        const workspaceClients = clients
          .filter((c) => c.workspace.id === w.id)
          .map((c) => {
            const queriedInfo = Applications.query(c.initialClass);
            /** @type {ClientDesktopInfo | undefined} */
            let appInfo;
            if (queriedInfo && queriedInfo[0]) {
              appInfo = {
                name: queriedInfo[0].name,
                description: queriedInfo[0].description,
                icon: queriedInfo[0].iconName,
              };
            }
            return {
              id: c.address,
              pid: c.pid,
              title: c.title,
              active: c.address === activeClient.address,
              position: c.at,
              size: c.size,
              hidden: c.hidden,
              floating: c.floating,
              pinned: c.pinned,
              fullscreen: c.fullscreen,
              desktopInfo: appInfo,
            };
          });
        return {
          id: w.id,
          name: w.name,
          active: w.id === m.activeWorkspace.id,
          clients: workspaceClients,
        };
      });

    return {
      id: m.id,
      name: m.name,
      active: m.focused,
      position: [m.x, m.y],
      size: [m.width, m.height],
      scale: m.scale,
      workspaces: monitorWorkspaces,
    };
  });
}
