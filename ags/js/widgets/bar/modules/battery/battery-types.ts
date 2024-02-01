// TODO: Fix types
type BatteryStatus = typeof import('resource:///com/github/Aylur/ags/service/battery.js');

interface BatteryConfig extends ModuleConfig {
  formatTooltip(battery: BatteryStatus): string;
}

interface BatteryArgs extends Partial<BatteryConfig> { }
