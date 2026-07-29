import { clamp } from "./math";

export class FocusListItem<T> {
  /** Value of the item. */
  #item: T;
  /** Time that the object was last activated at. */
  #activatedTimestamp: number | undefined;
  /** Time that the object was last activated at that is not updated by history cycling. */
  #historyTimestamp: number | undefined;

  /**
   * @param item
   * Value of the item.
   */
  constructor(item: T) {
    this.#item = item;
    this.#activatedTimestamp = undefined;
    this.#historyTimestamp = undefined;
  }

  /** Value of the item. */
  get item(): T {
    return this.#item;
  }

  /** Time that the object was last activated at. */
  get activatedTimestamp(): number | undefined {
    return this.#activatedTimestamp;
  }

  /**
   * @package
   * Time that the object was last activated at that is not updated by history cycling.
   */
  get _historyTimestamp(): number | undefined {
    return this.#historyTimestamp;
  }

  /**
   * @package
   *
   * @param updateHistory
   * Whether to update history timestamp too.
   */
  _activate(updateHistory: boolean = true) {
    const now = performance.timeOrigin + performance.now();
    this.#activatedTimestamp = now;
    if (updateHistory) {
      this.#historyTimestamp = now;
    }
  }
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
    return this.#activateAtConfigurableTimestamp(index);
  }

  /**
   * Activate object at the index without updating `activatedTime` nor `historyTime`.
   *
   * @param index
   * Target index to activate.
   * @param updateHistory
   * Whether to update history timestamp too.
   *
   * @returns
   * Whether activation was successful.
   */
  #activateAtConfigurableTimestamp(
    index: number,
    updateHistory: boolean = true,
  ): boolean {
    if (index < 0 || index >= this.length) {
      return false;
    }

    this.#active = index;
    this.#items[this.#active]._activate(updateHistory);

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
   * Whether activation out of bounds should default to the most old / recent item.
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

    const byHistoryTimestamp = this.#items
      .map((item, i) => ({ item, i }))
      .sort(
        (a, b) =>
          (a.item._historyTimestamp ?? -1) - (b.item._historyTimestamp ?? -1),
      )
      .map(({ i }) => i);

    const current = byHistoryTimestamp.findIndex((i) => i === this.#active);
    if (current < 0) {
      return false;
    }

    let target = current + offset;
    if (!shouldClamp && (target < 0 || target >= byHistoryTimestamp.length)) {
      return false;
    }

    target = clamp(target, 0, byHistoryTimestamp.length - 1);
    return this.#activateAtConfigurableTimestamp(
      byHistoryTimestamp[target],
      false,
    );
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

    const byActivatedTimestamp = this.#items
      .map((item, i) => ({ item, i }))
      .sort(
        (a, b) =>
          (a.item.activatedTimestamp ?? -1) - (b.item.activatedTimestamp ?? -1),
      )
      .map(({ i }) => i);

    const current = byActivatedTimestamp.findIndex((i) => i === this.#active);
    if (current < 0) {
      return false;
    }

    let target = current - 1;
    if (target < 0 || target >= byActivatedTimestamp.length) {
      return false;
    }

    return this.activateAt(byActivatedTimestamp[target]);
  }

  /**
   * Insert items to the list at an index.
   * If the list was previously empty, will always focus the first element.
   *
   * @param index
   * Index to insert values at.
   * The first item from `values` will be put into that index.
   * @param values
   * Items to insert into the list.
   *
   * @returns
   * Inserted items if the insertion was successful, undefined otherwise.
   */
  public insertAt(index: number, values: T[]): FocusListItem<T>[] | undefined {
    if (index < 0 || index > this.length) {
      return undefined;
    }

    const items = values.map<FocusListItem<T>>(
      (value) => new FocusListItem(value),
    );

    this.#items.splice(index, 0, ...items);

    if (this.#active === undefined) {
      this.activateAt(0);
    } else if (index <= this.#active) {
      this.#active += values.length;
    }

    return items;
  }

  /**
   * Insert items to the beginning list.
   * If the list was previously empty, will always focus the first element.
   *
   * @param values
   * Items to insert into the list.
   *
   * @returns
   * Inserted items (insertion is always a success because we can insert to the beginning of even an empty list).
   */
  public insertFirst(values: T[]): FocusListItem<T>[] {
    return this.insertAt(0, values)!;
  }

  /**
   * Insert items to the end list.
   * If the list was previously empty, will always focus the first element.
   *
   * @param values
   * Items to insert into the list.
   *
   * @returns
   * Inserted items (insertion is always a success because we can insert to the end of even an empty list).
   */
  public insertLast(values: T[]): FocusListItem<T>[] {
    return this.insertAt(this.length, values)!;
  }

  /**
   * Insert items relative to the active element.
   * If the list was previously empty, will always focus the first element.
   *
   * @param offset
   * Offset from active index to insert to.
   * The first item from `values` will be put into that index.
   * @param values
   * Items to insert into the list.
   * @param options
   * Other options.
   * @param options.shouldClamp
   * Whether activation out of bounds should default to inserting to the beginning / end.
   *
   * @returns
   * Inserted items if the insertion was successful, undefined otherwise.
   */
  public insertRelative(
    offset: number,
    values: T[],
    { shouldClamp = false }: { shouldClamp?: boolean } = {},
  ): FocusListItem<T>[] | undefined {
    let index = (this.#active ?? 0) + offset;
    if (shouldClamp) {
      index = clamp(index, 0, this.length);
    }

    return this.insertAt(index, values);
  }

  /**
   * Remove object at the index.
   *
   * @param index
   * Target index to remove.
   * @param options
   * Other options.
   * @param options.fallback
   * Which element to activate if old active is removed.
   *
   * @returns
   * Removed item if the deletion was successful, undefined otherwise.
   */
  removeAt(
    index: number,
    {
      fallback = "most_recent",
    }: {
      fallback?: "first" | "last" | "previous" | "next" | "most_recent";
    } = {},
  ): FocusListItem<T> | undefined {
    if (this.#active === undefined) {
      return undefined;
    }

    if (index < 0 || index >= this.length) {
      return undefined;
    }

    const [removed] = this.#items.splice(index, 1);

    if (this.length === 0) {
      // List is empty, deselect
      this.#active = undefined;
    } else if (index < this.#active) {
      // Item before was removed, shift
      this.#active -= 1;
    } else if (index === this.#active) {
      // Active item was removed, fallback
      let active: number;
      switch (fallback) {
        case "first": {
          active = 0;
          break;
        }
        case "last": {
          active = this.length - 1;
          break;
        }
        case "next": {
          active = this.#active;
          break;
        }
        case "previous": {
          active = this.#active - 1;
          break;
        }
        case "most_recent": {
          active = this.#items.reduce(
            (best, item, i) =>
              (item.activatedTimestamp ?? -1) >
              (this.#items[best].activatedTimestamp ?? -1)
                ? i
                : best,
            0,
          );
          break;
        }
      }

      this.activateAt(clamp(active, 0, this.length - 1));
    }

    return removed;
  }

  /**
   * Remove object from the beginning of the list.
   *
   * @param options
   * Options from {@link removeAt}.
   *
   * @returns
   * Removed item if the deletion was successful, undefined otherwise.
   */
  removeFirst(
    options: Parameters<this["removeAt"]>[1] = {},
  ): FocusListItem<T> | undefined {
    return this.removeAt(0, options);
  }

  /**
   * Remove object from the end of the list.
   *
   * @param options
   * Options from {@link removeAt}.
   *
   * @returns
   * Removed item if the deletion was successful, undefined otherwise.
   */
  removeLast(
    options: Parameters<this["removeAt"]>[1] = {},
  ): FocusListItem<T> | undefined {
    return this.removeAt(this.length - 1, options);
  }

  /**
   * Remove object at the offset relative to the currently active one.
   *
   * @param offset
   * Offset from active index to remove.
   * @param options
   * Options from {@link removeAt}.
   * @param options.shouldClamp
   * Whether removal out of bounds should default to removing from the beginning / end.
   *
   * @returns
   * Removed item if the deletion was successful, undefined otherwise.
   */
  removeRelative(
    offset: number,
    {
      shouldClamp = false,
      ...options
    }: {
      shouldClamp?: boolean;
    } & Parameters<this["removeAt"]>[1] = {},
  ): FocusListItem<T> | undefined {
    if (this.#active === undefined) {
      return undefined;
    }

    let index = this.#active + offset;
    if (shouldClamp) {
      index = clamp(index, 0, this.length - 1);
    }

    return this.removeAt(index, options);
  }

  /**
   * Remove object that equals the target.
   *
   * @param item
   * Target to remove.
   * @param options
   * Options from {@link removeAt}.
   * @param options.equalityCheck
   * Predicate to use to check whether an object matches the target.
   *
   * @returns
   * Removed item if the deletion was successful, undefined otherwise.
   */
  removeObject(
    item: T,
    {
      equalityCheck = (a, b) => a === b,
      ...options
    }: {
      equalityCheck?: (a: T, b: T) => boolean;
    } & Parameters<this["removeAt"]>[1] = {},
  ): FocusListItem<T> | undefined {
    const index = this.#items.findIndex((i) => equalityCheck(i.item, item));
    if (index < 0) {
      return undefined;
    }
    return this.removeAt(index, options);
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
   * Not suggested, but can also be used to modify new elements to be inserted in place through `existing` and `incoming` parameters.
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
    const usedIndices = new Set<number>();

    const reused = items.map<FocusListItem<T>>((item) => {
      const index = this.#items.findIndex(
        (existing, i) =>
          !usedIndices.has(i) && equalityCheck(existing.item, item),
      );
      if (index < 0) {
        // Item did not exist, crate a new one
        return new FocusListItem(item);
      }

      // Item existed, reuse
      usedIndices.add(index);
      return this.#items[index];
    });

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
          active = reused.reduce(
            (best, item, i) =>
              (item.activatedTimestamp ?? -1) >
              (reused[best].activatedTimestamp ?? -1)
                ? i
                : best,
            0,
          );
          break;
        }
      }
    }

    this.#items.splice(0, this.length, ...reused);
    if (active !== undefined) {
      this.activateAt(active);
    } else {
      this.#active = undefined;
    }
  }
}
