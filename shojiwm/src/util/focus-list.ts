import { clamp } from "./math";

export interface FocusListItem<T> {
  /** Value of the item. */
  item: T;
  /** Time that the object was last activated at. */
  activatedTime: Date | undefined;
  /**
   * @package
   * Time that the object was last activated at that is not updated by history cycling.
   */
  historyTime: Date | undefined;
}

/**
 * List that keeps track of which item is active and when it was activated.
 *
 * # Invariants
 * - `activeIndex` and `activeObject` are undefined if and only if `items` is empty, i.e. if the list is not empty there is always an item selected.
 * - As a consequence, `activeObject` will always have the greatest `activatedTime`.
 */
export class FocusList<T> {
  /** List of items. */
  #items: FocusListItem<T>[];
  /** Index of the active element, undefined if `items` is empty. */
  #active: number | undefined;

  /**
   * @param items
   * List to initialize the focus list with.
   * If contains at least 1 item, will auto-select the very first one.
   */
  constructor(items: T[] = []) {
    // Default values
    this.#items = [];
    this.#active = undefined;

    // Actually construct
    this.setItems(items);
  }

  /** List of items. */
  get items(): readonly FocusListItem<T>[] {
    return this.#items;
  }

  /** Length of the list. */
  get length(): number {
    return this.#items.length;
  }

  /** Index of the active element, undefined if `items` is empty. */
  get activeIndex(): number | undefined {
    return this.#active;
  }

  /** Object that is the active element, undefined if `items` is empty. */
  get activeObject(): FocusListItem<T> | undefined {
    return this.#active === undefined ? undefined : this.#items[this.#active];
  }

  /**
   * Activate object at the index.
   *
   * @param index
   * Target index to activate.
   *
   * @returns
   * Whether activation was successful.
   */
  activateAt(index: number): boolean {
    const result = this.#activateAtWithoutUpdatingTime(index);
    if (result) {
      const now = new Date();
      this.#items[this.#active!].activatedTime = now;
      this.#items[this.#active!].historyTime = now;
    }
    return result;
  }

  /**
   * Activate object at the index without updating `activatedTime` nor `historyTime`.
   *
   * @param index
   * Target index to activate.
   *
   * @returns
   * Whether activation was successful.
   */
  #activateAtWithoutUpdatingTime(index: number): boolean {
    if (index < 0 || index >= this.length) {
      return false;
    }

    this.#active = index;

    return true;
  }

  /**
   * Activate the first object in the list.
   *
   * @returns
   * Whether activation was successful.
   */
  activateFirst(): boolean {
    return this.activateAt(0);
  }

  /**
   * Activate the last object in the list.
   *
   * @returns
   * Whether activation was successful.
   */
  activateLast(): boolean {
    return this.activateAt(this.length - 1);
  }

  /**
   * Activate object at the offset relative to the currently active one.
   *
   * @param offset
   * Offset from active index to activate.
   * @param options
   * Other options.
   * @param options.shouldClamp
   * Whether activation out of bounds is reported to be successful or not.
   *
   * @returns
   * Whether activation was successful.
   */
  activateRelative(
    offset: number,
    { shouldClamp = false }: { shouldClamp?: boolean } = {},
  ): boolean {
    if (this.#active === undefined) {
      return false;
    }

    let index = this.#active + offset;
    if (shouldClamp) {
      index = clamp(index, 0, this.length - 1);
    }

    return this.activateAt(index);
  }

  /**
   * Activate an object that equals the target.
   *
   * @param item
   * Target item to activate.
   * @param options
   * Other options.
   * @param options.equalityCheck
   * Predicate to use to check whether an object matches the target.
   *
   * @returns Whether activation was successful.
   */
  activateObject(
    item: T,
    {
      equalityCheck = (a, b) => a === b,
    }: { equalityCheck?: (a: T, b: T) => boolean } = {},
  ): boolean {
    const index = this.#items.findIndex((i) => equalityCheck(i.item, item));
    if (index < 0) {
      return false;
    }
    return this.activateAt(index);
  }

  /**
   * Navigate the history and activate previously active objects.
   * Does not ping pong, so:
   * - `activateHistory(-1); activateHistory(-1)` is equivalent to `activateHistory(-2)`.
   * - `activateHistory(-1); activateHistory(1)` is equivalent to `activateHistory(0)` which is a noop.
   *
   * @param offset
   * Offset in the history to activate.
   * @param options
   * Other options.
   * @param options.shouldClamp
   * Whether activation out of bounds is reported to be successful or not.
   *
   * @returns
   * Whether activation was successful.
   */
  activateHistory(
    offset: number,
    { shouldClamp = false }: { shouldClamp?: boolean } = {},
  ): boolean {
    if (this.#active === undefined) {
      return false;
    }

    const byHistoryTime = [...this.#items.entries()]
      .sort(([_1, a], [_2, b]) => {
        if (a.historyTime === undefined && b.historyTime === undefined) {
          return 0;
        } else if (a.historyTime === undefined) {
          return -1;
        } else if (b.historyTime === undefined) {
          return 1;
        } else {
          return a.historyTime.getTime() - b.historyTime.getTime();
        }
      })
      .map(([i, _]) => i);

    const current = byHistoryTime.findIndex((i) => i === this.#active);
    if (current < 0) {
      return false;
    }

    let target = current + offset;
    if (!shouldClamp && (target < 0 || target >= byHistoryTime.length)) {
      return false;
    }

    target = clamp(target, 0, byHistoryTime.length - 1);
    const result = this.#activateAtWithoutUpdatingTime(byHistoryTime[target]);
    if (result) {
      const now = new Date();
      this.#items[this.#active!].activatedTime = now;
    }
    return result;
  }

  /**
   * Navigate the history and activate previously active object.
   * This version ping pongs, so:
   * - `activateMostRecent(); activateMostRecent()` is a noop.
   *
   * @returns
   * Whether activation was successful.
   */
  activateMostRecent(): boolean {
    if (this.#active === undefined) {
      return false;
    }

    const byActivatedTime = [...this.#items.entries()]
      .sort(([_1, a], [_2, b]) => {
        if (a.activatedTime === undefined && b.activatedTime === undefined) {
          return 0;
        } else if (a.activatedTime === undefined) {
          return -1;
        } else if (b.activatedTime === undefined) {
          return 1;
        } else {
          return a.activatedTime.getTime() - b.activatedTime.getTime();
        }
      })
      .map(([i, _]) => i);

    const current = byActivatedTime.findIndex((i) => i === this.#active);
    if (current < 0) {
      return false;
    }

    let target = current - 1;
    if (target < 0 || target >= byActivatedTime.length) {
      return false;
    }

    return this.activateAt(byActivatedTime[target]);
  }

  /**
   * Re-initialize the list with new values.
   * The reference to items is kept.
   *
   * @param items
   * List to initialize focus list with.
   * @param options
   * Other options.
   * @param options.preserveActive
   * Try to keep the last active object if it is present in the new list.
   * @param options.fallback
   * Which element to activate if old active is not found.
   * @param options.equalityCheck
   * Predicate to use to check whether an object matches the target.
   * Not suggested, but can also be used to modify new elements to be inserted in place through `incoming` parameter.
   */
  setItems(
    items: T[],
    {
      preserveActive = true,
      fallback = "first",
      equalityCheck = (existing, incoming) => existing === incoming,
    }: {
      preserveActive?: boolean;
      fallback?: "first" | "last" | "same_index" | "most_recent";
      equalityCheck?: (existing: T, incoming: T) => boolean;
    } = {},
  ) {
    const reused = items.map<FocusListItem<T>>(
      (item) =>
        this.#items.find((i) => equalityCheck(i.item, item)) ?? {
          item,
          activatedTime: undefined,
          historyTime: undefined,
        },
    );

    let active: number | undefined;
    if (
      preserveActive &&
      this.#active !== undefined &&
      reused.includes(this.#items[this.#active])
    ) {
      active = reused.indexOf(this.#items[this.#active]);
    } else if (reused.length !== 0) {
      switch (fallback) {
        case "first": {
          active = 0;
          break;
        }
        case "last": {
          active = reused.length - 1;
          break;
        }
        case "same_index": {
          active = Math.min(this.#active ?? 0, reused.length - 1);
          break;
        }
        case "most_recent": {
          let index = 0;
          for (const [i, item] of reused.entries()) {
            if (
              item.activatedTime !== undefined &&
              reused[index].activatedTime !== undefined &&
              item.activatedTime > reused[index].activatedTime!
            ) {
              index = i;
            }
          }
          active = index;
          break;
        }
      }
    }

    this.#items.splice(0, this.#items.length, ...reused);
    if (active !== undefined) {
      this.activateAt(active);
    }
  }
}
