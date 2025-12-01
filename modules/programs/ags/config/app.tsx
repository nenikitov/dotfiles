#!/usr/bin/env -S ags run

import app from "ags/gtk4/app"
import { Windows } from "./windows/index.tsx"

app.start({
  instanceName: "ne-shell",
  main: Windows,
})
