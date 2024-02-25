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

export function formatSeconds(seconds: number): string {
  let minutes = Math.floor(seconds / 60);
  seconds %= 60;

  let hours = Math.floor(minutes / 60);
  minutes %= 60;

  const days = Math.floor(hours / 24);
  hours %= 24;

  const time = [
    [days, "d"],
    [hours, "h"],
    [minutes, "m"],
    [seconds, "s"],
  ] as const;
  let largest = time.findIndex(([duration]) => duration > 0);
  if (largest === -1) {
    largest = time.length - 1;
  }

  return time
    .slice(largest)
    .map(([d, u]) => `${d}${u}`)
    .join(" ");
}
