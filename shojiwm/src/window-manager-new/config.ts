import { type Match, type OutputState } from "./match";

export interface Config {
  outputs: [
    Match<OutputState>,
    {
      focusOnStartup: boolean;
      staticWorkspaces: {
        name?: string;
      }[];
    },
  ][];
}

export const defaults: Config = {
  outputs: [],
};
