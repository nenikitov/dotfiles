import { WmConfig } from "services/window-manager";
import { BarConfig } from "widgets/bar";

export const windowManager: WmConfig = {
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

export const bar: BarConfig = {
  position: "top",
  layout: {
    start: ["workspaces"],
    center: [],
    end: [
      {
        name: "battery",
        config: {
          format: false,
          icon: false,
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
