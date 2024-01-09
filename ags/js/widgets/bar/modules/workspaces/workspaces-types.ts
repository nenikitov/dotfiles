interface WorkspacesConfig extends ModuleConfig {
  format: (workspace: Workspace) => string;
  formatTooltip: (workspace: Workspace) => string;
  hideEmpty: boolean;
  allMonitors: boolean;
  maxDots: 3;
  special: "hide" | "first" | "last";
}

interface WorkspacesArgs extends Partial<WorkspacesConfig> {
  monitor: number;
}
