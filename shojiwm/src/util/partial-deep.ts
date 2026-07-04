import { type IsTuple } from "./type";

// prettier-ignore
export type PartialDeep<T> =
  // PartialDeep<Anything> = Anything | undefined
  | undefined
  // PartialDeep<Primitive> -> primitive as is
  | (T extends (
        | null
        | undefined
        | boolean
        | number
        | bigint
        | string
        | symbol
        | Date
        | Function
    ) ?
      T
    // PartialDeep<Collection<T>> -> Collection<PartialDeep<T>>
    // This allows to get members like .length while making inner values partial
    : T extends Array<infer V> ?
      T extends IsTuple<T> ?
        // Don't clobber tuples
        { [K in keyof T]: PartialDeep<T[K]> }
      : Array<PartialDeep<V>>
    : T extends ReadonlyArray<infer V> ?
      T extends IsTuple<T> ?
        // Don't clobber tuples
        { readonly [K in keyof T]: PartialDeep<T[K]> }
      : ReadonlyArray<PartialDeep<V>>
    : T extends Set<infer V> ? Set<PartialDeep<V>>
    : T extends ReadonlySet<infer E> ? ReadonlySet<PartialDeep<E>>
    : T extends Map<infer K, infer V> ? Map<K, PartialDeep<V>>
    : T extends ReadonlyMap<infer K, infer V> ? ReadonlyMap<K, PartialDeep<V>>
    // PartialDeep<{K: V}> -> {K: PartialDeep<V>}
    : T extends object ? { [K in keyof T]?: PartialDeep<T[K]> }
    // Normally shouldn't occur, but if happens I made a mistake
    : never);
