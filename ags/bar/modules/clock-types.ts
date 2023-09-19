interface ClockConfig extends ModuleConfig {
  format: string;
  formatTooltip: string;
  interval: number;
  justification: import('resource:///com/github/Aylur/ags/widget.js').Justification;
}

interface ClockArgs extends Partial<ClockConfig> { }
