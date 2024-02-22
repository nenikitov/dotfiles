export function range(length: number, start: number = 0): number[] {
  return Array.from({ length }, (_, i) => i + start);
}

export function groupBy<T, K extends string | number | symbol>(
  array: T[],
  callback: (e: T) => K
): Record<K, T[]> {
  // @ts-expect-error: 2322 - It will become a record, for now it's empty
  const result: Record<K, T[]> = {};
  for (const e of array) {
    (result[callback(e)] ||= []).push(e);
  }
  return result;
}
