export type IsTuple<T extends ReadonlyArray<unknown>> =
  number extends T["length"] ? false : true;

// https://stackoverflow.com/a/75872704
export type Intersection<T extends any[]> = {
  [K in keyof T]: (x: T[K]) => void;
} extends {
  [K: number]: (x: infer I) => void;
}
  ? I
  : never;
