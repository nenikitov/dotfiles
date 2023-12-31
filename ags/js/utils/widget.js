/**
 * @typedef {import("types/widgets/window").default} Widget
 */

import _Gdk from "gi://Gdk";
/** @type {import('gdk-3.0/gdk-3.0').default} */
const Gdk = _Gdk;

import { range } from "./iterator.js";

/**
 * @template {Widget} T
 * @param {(monitor: number) => T} widget
 * @returns T[]
 */
export function forEveryMonitor(widget) {
  const count = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(count).map(widget);
}
