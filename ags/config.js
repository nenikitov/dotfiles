import App from "resource:///com/github/Aylur/ags/app.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

const out = `${App.configDir}/build/main.js`;
const entry = `${App.configDir}/ts/main.ts`;

const externalLibraries = ["resource://*", "gi://*"];

try {
  await Utils.execAsync([
    "bun",
    "build",
    entry,
    "--outfile",
    out,
    ...externalLibraries.flatMap((l) => ["--external", l]),
  ]);

  const main = await import(`file://${out}`);
  App.config(main.config);
} catch (error) {
  console.error(/** @type {Error} */ (error));
  App.Quit();
}
