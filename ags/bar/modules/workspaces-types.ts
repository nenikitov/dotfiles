interface WorkspacesConfig {
  format: (workspace: Workspace) => string;
  formatTooltip: (workspace: Workspace) => string;
  hideEmpty: boolean;
  allMonitors: boolean;
  vertical: boolean;
}

interface WorkspacesArgs extends Partial<WorkspacesConfig> {
  monitor: import('resource:///com/github/Aylur/ags/service/hyprland.js').Monitor;
}
