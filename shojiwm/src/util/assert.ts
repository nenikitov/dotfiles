export function assertType<T>(value: unknown): asserts value is T {}

export function unreachable(message?: string): never {
  throw new Error(message);
}
