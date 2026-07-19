import {
  COMPOSITOR,
  createWindowState,
  type OutputInfo,
  type WaylandWindow,
  type WindowPosition,
} from "shoji_wm";
import { FocusListDynamic, FocusListStrict } from "../../util/focus-list";
import { Sides } from "../../util/measurement";
import { todo } from "../../util/assert";

export const state = {
  rect: createWindowState<WindowPosition>("rect", {
    default: (_) => ({ x: 0, y: 0, width: 0, height: 0 }),
  }),
  managed: createWindowState<Window>("managed"),
} as const;

export class Layout {
  /** Child monitors. */
  readonly #outputs: FocusListStrict<Output>;

  public constructor() {
    this.#outputs = new FocusListStrict();
  }

  public get outputs(): readonly Output[] {
    return this.#outputs.items;
  }

  public get outputActive(): Output | null {
    return this.#outputs.activeObject;
  }

  public updateOutputs(outputs: OutputInfo[]) {
    if (outputs.length === 0) {
      todo(
        "No monitors connected, orphan all workspaces until at least one output is connected",
      );
    }

    const live = outputs
      .filter((l) => l.enabled)
      .map((l) => {
        const output =
          this.#outputs.items.find(
            // TODO: Identify by monitor's name rather than by connector's name
            (o) => o.handle.name === l.name,
          ) ?? new Output(this, undefined, l);
        output.handle = l;
        return output;
      });

    const liveNames = live.map((l) => l.handle.name);

    const active =
      (
        live.some(
          (l) => l.handle.name === this.#outputs.activeObject?.handle.name,
        )
      ) ?
        this.#outputs.activeObject!
      : live[0];

    this.#outputs.items
      .filter((o) => !liveNames.includes(o.handle.name))
      .forEach((removed) => {
        todo("Migrate workspaces to active");
      });

    this.#outputs.rebuild(live);
    this.#outputs.activateObject(active);
    this.applyLayout();
  }

  public windowManage(window: WaylandWindow): Window | null {
    if (this.#outputs.activeObject !== null) {
      return this.#outputs.activeObject.windowManage(window);
    }
    return null;
  }

  public applyLayout(dirtyOutputs: readonly Output[] = this.#outputs.items) {
    for (const output of dirtyOutputs) {
      output.applyLayout();
    }
  }
}

export class Output {
  /** Parent layout. */
  #layout: Layout;
  /** Child workspaces. */
  readonly #workspaces: FocusListDynamic<Workspace>;

  /** Wayland's handle. */
  #handle: OutputInfo;
  /** User reserved areas (does not include layer reserved space like bars and widgets). */
  #struts: Sides<number>;
  /** Size of the gaps between workspaces. */
  #gap: number;

  constructor(
    layout: Layout,
    workspaces: Workspace[] = [],
    handle: OutputInfo,
    struts: Sides<number> = new Sides(8),
  ) {
    this.#layout = layout;
    this.#workspaces = new FocusListDynamic(
      () => new Workspace(this),
      (w) => !w.isDirty,
      workspaces,
    );

    this.#handle = handle;
    this.#struts = struts;
    this.#gap = 16;
  }

  public get handle(): OutputInfo {
    return this.#handle;
  }

  public set handle(value: OutputInfo) {
    this.#handle = value;
  }

  /**
   * Rectangle covering the entire output.
   * Does not include output position.
   */
  public get rectFull(): WindowPosition | null {
    if (this.#handle.resolution === undefined) {
      return null;
    }

    return {
      x: 0,
      y: 0,
      width: this.#handle.resolution.width / this.#handle.scale,
      height: this.#handle.resolution.height / this.#handle.scale,
    };
  }

  /**
   * Rectangle covering safe area of the output (protected from covering exclusive widgets and user defined struts).
   * Does not include output position.
   */
  public get rectSafe(): WindowPosition | null {
    const rectUsable = COMPOSITOR.layer.usableArea(this.#handle.name);
    if (rectUsable === null) {
      return null;
    }

    return {
      x: rectUsable.x + this.#struts.left - this.#handle.position.x,
      y: rectUsable.y + this.#struts.top - this.#handle.position.y,
      width:
        rectUsable.width / this.#handle.scale
        - this.#struts.left
        - this.#struts.right,
      height:
        rectUsable.height / this.#handle.scale
        - this.#struts.top
        - this.#struts.bottom,
    };
  }

  public windowManage(window: WaylandWindow): Window | null {
    if (this.#workspaces.activeObject !== null) {
      const managed = this.#workspaces.activeObject.windowManage(window);
      this.applyLayout([this.#workspaces.activeObject]);
      return managed;
    }
    return null;
  }

  public applyLayout(
    dirtyWorkspaces: readonly Workspace[] = this.#workspaces.items,
  ) {
    const rectFull = this.rectFull;
    const rectSafe = this.rectSafe;

    if (rectFull === null || rectSafe === null) {
      return;
    }

    for (const workspace of dirtyWorkspaces) {
      workspace.applyLayout(rectFull, rectSafe);
    }
  }
}

export class Workspace {
  /** Parent output. */
  #output: Output;
  /** Child strips (scrolling layer). */
  readonly #strips: FocusListStrict<Strip>;
  /** Child windows (floating layer). */
  readonly #floating: FocusListStrict<Window>;

  /** Whether floating or tiled layer is focused. */
  #isFloatingFocused: boolean;
  /**
   * View offset of the scrolling layer.
   * Is relative to the top-left edge of the output, so gaps and struts should be handled here too.
   */
  #offset: number;
  /** Size of the gaps between strips. */
  #gap: number;

  constructor(output: Output) {
    this.#output = output;
    this.#strips = new FocusListStrict();
    this.#floating = new FocusListStrict();

    this.#isFloatingFocused = false;
    this.#offset = 0;
    this.#gap = 8;
  }

  public get isDirty(): boolean {
    return this.#strips.length !== 0 || this.#floating.length !== 0;
  }

  public windowManage(window: WaylandWindow): Window | null {
    // TODO: Implement configurable window addition strategy
    // TODO: Handle floating and transient windows too
    let strip: Strip;
    if (
      this.#strips.activeObject === null
      || this.#strips.activeObject.windows.length >= 2
    ) {
      [strip] = this.#strips.insertRelative(1, new Strip(this));
    } else {
      strip = this.#strips.activeObject;
    }

    const managed = strip.windowManage(window);
    managed.handle.state[state.managed].set(managed);
    return managed;
  }

  public applyLayout(rectFull: WindowPosition, rectSafe: WindowPosition) {
    for (const window of this.#floating.items) {
      window.applyLayout(window.size as WindowPosition);
    }

    let x = rectSafe.x;
    for (const strip of this.#strips.items) {
      x += strip.applyLayout(x, rectFull, rectSafe) + this.#gap;
    }
  }
}

export class Strip {
  /** Parent workspace. */
  #workspace: Workspace;
  /** Child windows. */
  readonly #windows: FocusListStrict<Window>;

  /**
   * Size in the scrolling direction that the strip wants to take up.
   * Is not affected by maximizing / fullscreening, this is the size it will return to after going back to normal size mode.
   */
  #size: number;
  /** Sizing mode seen by the window manager, may not actually be what sizing mode windows inside use. */
  #sizeMode: SizeMode;
  /** Whether this strip is tabbed (only active window is displayed taking up the entire stripe) or stacked (all windows are displayed next to each other). */
  #isTabbed: boolean;
  /** Size of the gaps between windows. */
  #gap: number;

  constructor(workspace: Workspace) {
    this.#workspace = workspace;
    this.#windows = new FocusListStrict();

    // TODO: Have an actual not-hardcoded proportional size
    this.#size = 900;
    this.#sizeMode = SizeMode.NORMAL;
    this.#isTabbed = false;
    this.#gap = 8;
  }

  public get size(): number {
    return this.#size;
  }

  public get windows(): readonly Window[] {
    return this.#windows.items;
  }

  public windowManage(window: WaylandWindow): Window {
    // TODO: Figure out what size fits here the best
    const [managed] = this.#windows.insertLast(new Window(this, window, 100));
    return managed;
  }

  public applyLayout(
    x: number,
    rectFull: WindowPosition,
    rectSafe: WindowPosition,
  ): number {
    let y = this.#sizeMode === SizeMode.FULLSCREEN ? rectFull.y : rectSafe.y;
    let width =
      this.#sizeMode === SizeMode.FULLSCREEN ? rectFull.width
      : this.#sizeMode === SizeMode.MAXIMIZED ? rectSafe.width
      : this.#size;
    let height =
      this.#sizeMode === SizeMode.FULLSCREEN ?
        rectFull.height
      : rectSafe.height;

    if (this.#isTabbed || this.#sizeMode === SizeMode.FULLSCREEN) {
      for (const window of this.#windows.items) {
        window.applyLayout({ x, y, width, height });
      }
    } else if (this.#windows.length > 0) {
      // TODO: Have an actual not-hardcoded proportional size
      const heightWindow =
        (height - (this.#windows.length - 1) * this.#gap)
        / this.#windows.length;

      for (const window of this.#windows.items) {
        window.applyLayout({ x, y, width, height: heightWindow });
        y += heightWindow + this.#gap;
      }
    }

    return width;
  }
}

export class Window {
  /** Parent strip (for tiled) or workspace (for floating). */
  #parent: Strip | Workspace;

  /** Wayland's handle. */
  readonly #handle: WaylandWindow;
  /** Sizing mode advertised to the handle, but may not actually be what sizing mode is actually applied. */
  #sizeMode: SizeMode;
  /**
   * Size / position that this window wants to take up.
   * For floating will be `WindowPosition` (ie size and position).
   * For scrolling will be a single number - size perpendicular to scrolling direction.
   * Is not affected by maximizing / fullscreening, this is the size it will return to after going back to normal size mode.
   */
  /// TODO: Generic or union?
  #size: WindowPosition | number;
  /** Computed position and size of the window in workspace space. */
  #rect: WindowPosition;

  constructor(
    parent: Strip | Workspace,
    handle: WaylandWindow,
    size: WindowPosition | number,
  ) {
    this.#parent = parent;
    this.#handle = handle;
    this.#sizeMode = SizeMode.NORMAL;
    this.#size = size;
    this.#rect = { x: 0, y: 0, width: 0, height: 0 };
  }

  public get size(): WindowPosition | number {
    return this.#size;
  }

  public get handle(): WaylandWindow {
    return this.#handle;
  }

  public applyLayout(rect: WindowPosition) {
    this.#rect = rect;
    this.#handle.state[state.rect].set(rect);
  }
}

export class SizeMode {
  public static readonly NORMAL = new SizeMode();
  public static readonly MAXIMIZED = new SizeMode();
  public static readonly FULLSCREEN = new SizeMode();

  private constructor() {}
}
