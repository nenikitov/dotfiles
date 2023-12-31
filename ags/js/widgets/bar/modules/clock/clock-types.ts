interface ClockConfig extends ModuleConfig {
  format: string;
  formatTooltip: string;
  interval: number;
}

interface ClockArgs extends Partial<ClockConfig> {}
