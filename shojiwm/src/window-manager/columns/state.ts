import {
  createWindowState,
  type Signal,
  type WaylandWindow,
  type WindowStateKey,
} from "shoji_wm";
import { type ManagedWindowRect } from "shoji_wm/types";

export const state = {
  rect: createWindowState<ManagedWindowRect>("rect", {
    default: (window) => window.position,
  }),
} as const;
