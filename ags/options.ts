import { WmConfig } from "services/window-manager";
import { BarConfig } from "widgets/bar";

export const windowManager: WmConfig = {
  workspaceNames: {
    default: {
      general: [
        { icon: "", name: "Home" },
        { icon: "", name: "Terminal" },
        { icon: "", name: "Web" },
        { icon: "", name: "Media" },
        { icon: "", name: "Communication" },
      ],
      special: { icon: "", name: "Special" },
    },
  },
  completeWorkspaces: "name-only",
  workspacesPerMonitor: 10,
};

export const bar: BarConfig = {
  position: "top",
  layout: {
    start: [
      {
        name: "workspaces",
        config: { special: "hide" },
      },
    ],
    center: [],
    end: [
      "system-tray",
      "keyboard-layout",
      {
        name: "system-status",
        config: {
          battery: {
            format: false,
          },
        },
      },
      {
        name: "clock",
        config: {
          format: "%H:%M:%S\n%a %Y-%m-%d",
          formatTooltip: "%H:%M:%S\n%A\n%B %d, %Y\n%Z (%:z)",
        },
      },
    ],
  },
};
