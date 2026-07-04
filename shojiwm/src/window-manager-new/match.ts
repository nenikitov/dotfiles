import { type OutputInfo } from "shoji_wm";
import { type Workspace } from ".";
import type { Direction } from "./direction";

export class Match<T> {
  private constructor(private readonly inner: (value: T) => boolean) {}

  public static eq<T>(value: T): Match<T> {
    return new Match((v) => v === value);
  }

  public static includes<T extends { includes: (value: I) => boolean }, I>(
    value: I,
  ): Match<T> {
    return new Match<T>((v) => v.includes(value));
  }

  public static output({
    connector,
    direction,
    index,
    indexRelative,
  }: {
    connector?: Match<string>;
    direction?: Match<Direction>;
    index: Match<number>;
    indexRelative: Match<number>;
  }): Match<OutputState> {
    return new Match((value) => {
      let matches = true;

      if (connector !== undefined && value.info.connector !== undefined) {
        matches &&= connector.matches(value.info.connector);
      }

      return matches;
    });
  }

  public static workspace({
    output,
    index,
    name,
    isEmpty,
  }: {
    output: Match<OutputState>;
    index: Match<number>;
    indexRelative: Match<number>;
    name: Match<string | undefined>;
    isEmpty: Match<boolean>;
  }): Match<WorkspaceState> {
    return new Match((value) => {
      let matches = true;

      return matches;
    });
  }

  public matches(value: T): boolean {
    return this.inner(value);
  }

  public static not<T>(match: Match<T>): Match<T> {
    return new Match((value) => !match.matches(value));
  }

  public not(): Match<T> {
    return Match.not(this);
  }

  public static or<T>(...matches: Match<T>[]): Match<T> {
    return new Match((value) => matches.some((m) => m.matches(value)));
  }

  public or(...matches: Match<T>[]): Match<T> {
    return Match.or(this, ...matches);
  }

  public static and<T>(...matches: Match<T>[]): Match<T> {
    return new Match((value) => matches.every((m) => m.matches(value)));
  }

  public and(...matches: Match<T>[]): Match<T> {
    return Match.and(this, ...matches);
  }
}

export type OutputState = {
  info: OutputInfo;
  current: boolean;
};

export type WorkspaceState = {
  info: Workspace;
  // TODO
};
