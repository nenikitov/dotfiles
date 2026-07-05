import { read, type OutputInfo, type WaylandWindow } from "shoji_wm";
import { type Workspace } from ".";
import { type Direction } from "./direction";

export class Match<T> {
  private constructor(private readonly inner: (value: T) => boolean) {}

  // HACK: For whatever reason, member function causes a hang, but arrow property does not
  public readonly matches = (value: T): boolean => {
    return this.inner(value);
  };

  public static eq<T>(value: T): Match<T> {
    return new Match((v) => v === value);
  }

  public static includes<T extends { includes: (value: I) => boolean }, I>(
    value: I,
  ): Match<T> {
    return new Match((v) => v.includes(value));
  }

  public static regexFull(regex: RegExp): Match<string> {
    const anchored = new RegExp(`^(?:${regex.source})$`, regex.flags);
    return new Match((v) => anchored.test(v));
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
  }): Match<WaylandWindow> {
    return new Match((value) => {
      let matches = true;

      return matches;
    });
  }

  public static window({
    id,
    title,
    appId,
    workspace,
    active,
    minimized,
    maximized,
    fullscreen,
    urgent,
    tiled,
  }: {
    id?: Match<string>;
    title?: Match<string>;
    appId?: Match<string | undefined>;
    workspace?: Match<WorkspaceState>;
    active?: Match<boolean>;
    minimized?: Match<boolean>;
    maximized?: Match<boolean>;
    fullscreen?: Match<boolean>;
    urgent?: Match<boolean>;
    tiled?: Match<boolean>;
  }): Match<WindowState> {
    return new Match((window) => {
      let matches = true;

      if (id) {
        matches &&= id.matches(window.info.id);
      }
      if (active) {
        matches &&= active.matches(read(window.info.isFocused));
      }
      if (tiled) {
        matches &&= tiled.matches(!read(window.info.isFloating));
      }

      return matches;
    });
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

export type WindowState = {
  info: WaylandWindow;
};
