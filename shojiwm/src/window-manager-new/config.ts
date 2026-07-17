export interface Config {
  outputs: [
    [], // TODO: Make a matcher instead
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
