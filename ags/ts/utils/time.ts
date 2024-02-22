const SECOND = 1000;
const MINUTE = 60 * SECOND;
const HOUR = 60 * MINUTE;

export function seconds(n: number): number {
  return SECOND * n;
}

export function minutes(n: number): number {
  return MINUTE * n;
}

export function hours(n: number): number {
  return HOUR * n;
}
