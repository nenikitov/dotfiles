import { WindowManagerConfig } from "services/window-manager";

export const windowManager: WindowManagerConfig = {
  defaultWorkspaces: {
    default: [
      { icon: "", name: "Home" },
      { icon: "", name: "Terminal" },
      { icon: "", name: "Web" },
      { icon: "", name: "Media" },
      { icon: "", name: "Communication" },
    ],
  },
  workspacesPerMonitor: 10,
};
