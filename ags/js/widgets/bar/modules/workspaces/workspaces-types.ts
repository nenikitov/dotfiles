interface WorkspacesConfig extends ModuleConfig {
  format: (workspace: Workspace) => string;
  formatTooltip: (workspace: Workspace) => string;
  hideEmpty: boolean;
  allMonitors: boolean;
}

interface WorkspacesArgs extends Partial<WorkspacesConfig> {
  monitor: number;
}
