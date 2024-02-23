import * as options from "options";
import { App, Config } from "prelude";
import { forEveryMonitor } from "utils/widget";
import { Bar } from "widgets/bar/";

export const config: Config = {
  style: App.configDir + "/style.css",
  windows: [...forEveryMonitor(Bar(options.bar))],
};
