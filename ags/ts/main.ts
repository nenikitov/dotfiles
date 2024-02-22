import App from "resource:///com/github/Aylur/ags/app.js";
import { forEveryMonitor } from "utils/widget";
import Bar from "widgets/bar/bar";

export default {
  style: App.configDir + "/style.css",
  windows: [forEveryMonitor(Bar)],
};
