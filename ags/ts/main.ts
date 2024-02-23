import * as options from "options";
import { App } from "prelude";
import { forEveryMonitor } from "utils/widget";
import Bar from "widgets/bar/";

export default {
  style: App.configDir + "/style.css",
  windows: [forEveryMonitor(Bar(options.bar))],
};
