export type IsTuple<T extends ReadonlyArray<unknown>> =
  number extends T["length"] ? false : true;
