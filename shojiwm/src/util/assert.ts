export function assertType<T>(
  value: unknown,
  message?: string,
): asserts value is T {}

export function unreachable(message?: string): never {
  throw new Error(`UNREACHABLE: ${message ?? "not handled"}`);
}

export function todo(message?: string): never {
  throw new Error(`TODO: ${message ?? "not implemented"}`);
}
