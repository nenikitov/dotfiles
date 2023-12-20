import App from "resource:///com/github/Aylur/ags/app.js";
import Bar from "./js/widgets/bar/bar.js";

import { forEveryMonitor } from "./js/utils/widget.js";

export default {
  style: App.configDir + "/style.css",
  windows: [forEveryMonitor(Bar)],
};
