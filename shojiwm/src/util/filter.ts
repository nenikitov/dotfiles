import { type Workspace } from "../window-manager-new";
import { type Intersection } from "./type";

export class Filter<T> {
  // Instances
  private constructor(
    private readonly compileMatcher: (values: T[]) => (value: T) => boolean,
  ) {}

  public static workspace(filter: {}): Filter<Workspace> {}

  public static eq<T>(value: T): Filter<T> {
    return new Filter(() => (v) => v === value);
  }

  public static includes<T extends { includes: (value: I) => boolean }, I>(
    value: I,
  ): Filter<T> {
    return new Filter(() => (v) => v.includes(value));
  }

  public static regexFull(regex: RegExp): Filter<string> {
    const anchored = new RegExp(`^(?:${regex.source})$`, regex.flags);
    return new Filter(() => (v) => anchored.test(v));
  }

  public static best<T>(predicate: (best: T, value: T) => boolean): Filter<T> {
    return new Filter((values) => {
      if (values.length < 1) {
        return () => false;
      }

      let best = values[0];
      for (const value of values) {
        if (predicate(best, value)) {
          best = value;
        }
      }

      return (value) => value === best;
    });
  }

  public static min<T>(): Filter<T> {
    return Filter.best((best, value) => value < best);
  }

  public static max<T>(): Filter<T> {
    return Filter.best((best, value) => value > best);
  }

  // Operations on self
  public static not<T>(filter: Filter<T>): Filter<T> {
    return new Filter((values) => {
      const matcher = filter.compileMatcher(values);
      return (value) => !matcher(value);
    });
  }

  public not(): Filter<T> {
    return Filter.not(this);
  }

  public static or<F extends Filter<any>[]>(
    ...filters: F
  ): Filter<Intersection<ExtractTs<F>>> {
    return new Filter((values) => {
      const matchers = filters.map((f) => f.compileMatcher(values));
      return (value) => matchers.some((matcher) => matcher(value));
    });
  }

  public or<F extends Filter<any>[]>(
    ...filters: F
  ): Filter<Intersection<ExtractTs<[this, ...F]>>> {
    return Filter.or(this, ...filters);
  }

  public static and<T>(...filters: Filter<T>[]): Filter<T> {
    return new Filter((values) => {
      const matchers = filters.map((f) => f.compileMatcher(values));
      return (value) => matchers.every((matcher) => matcher(value));
    });
  }

  public and<F extends Filter<any>[]>(
    ...filters: F
  ): Filter<Intersection<ExtractTs<[this, ...F]>>> {
    return Filter.and(this, ...filters);
  }

  // Operations on collections
  public filter(values: T[]): T[] {
    const matcher = this.compileMatcher(values);
    return values.filter(matcher);
  }

  public filterIndices(values: T[]): number[] {
    const matcher = this.compileMatcher(values);
    return values.flatMap((value, i) => (matcher(value) ? [i] : []));
  }

  public some(values: T[]): boolean {
    const matcher = this.compileMatcher(values);
    return values.some(matcher);
  }

  public every(values: T[]): boolean {
    const matcher = this.compileMatcher(values);
    return values.every(matcher);
  }

  // HACK: For whatever reason, member function causes a hang when using `array.filter()`, but arrow property does not.
  // I suspect `this` has something to do wit it.
  public readonly matches = (value: T): boolean => {
    return this.compileMatcher([value])(value);
  };
}

type ExtractTs<F extends Filter<any>[]> = {
  [K in keyof F]: F[K] extends Filter<infer T> ? T : unknown;
};
