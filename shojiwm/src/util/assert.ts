export function assertType<T>(value: unknown, message?: string): asserts value is T {}

export function unreachable(message?: string): never {
  throw new Error(message);
}
