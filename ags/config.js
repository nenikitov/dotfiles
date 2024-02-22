import App from "resource:///com/github/Aylur/ags/app.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

const fileOut = `${App.configDir}/build/main.js`;
const fileEntry = `${App.configDir}/main.ts`;

try {
  await Utils.execAsync([
    "bun",
    "build",
    fileEntry,
    "--outfile",
    fileOut,
    ...["resource://*", "gi://*"].flatMap((lib) => ["--external", lib]),
  ]);
} catch (error) {
  console.error(/** @type {Error} */ (error));
  App.Quit();
}

export default (await import(`file://${fileOut}`)).default;
