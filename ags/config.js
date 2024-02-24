import App from "resource:///com/github/Aylur/ags/app.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

const fileOut = `${App.configDir}/build/main.js`;
const fileEntry = `${App.configDir}/ts/main.ts`;

const externalLibraries = ["resource://*", "gi://*"];

try {
  await Utils.execAsync([
    "bun",
    "build",
    fileEntry,
    "--outfile",
    fileOut,
    ...externalLibraries.flatMap((l) => ["--external", l]),
  ]);
} catch (error) {
  console.error(/** @type {Error} */ (error));
  App.Quit();
}

const main = await import(`file://${fileOut}`);

export default main.config;
