export enum FallbackStrategy {
  FIRST,
  LAST,
  SAME_INDEX,
}

export interface FocusListItem<T> {
  item: T;
  focusedAt: Date | undefined;
}

export class FocusList<T> {
  #items: FocusListItem<T>[];
  #active: number | undefined;

  constructor(items: T[] = []) {
    // Default values
    this.#items = [];
    this.#active = undefined;

    // Actually construct
    this.setItems(items);
  }

  get items(): readonly FocusListItem<T>[] {
    return this.#items;
  }

  setItems(
    items: T[],
    {
      preserveActive = true,
      fallback = FallbackStrategy.FIRST,
      equalityCheck = (existing, incoming) => existing === incoming,
    }: {
      preserveActive?: boolean;
      fallback?: FallbackStrategy;
      equalityCheck?: (existing: T, incoming: T) => boolean;
    } = {},
  ) {
    const reused = items.map(
      (item) =>
        this.#items.find((i) => equalityCheck(i.item, item)) ?? {
          item,
          focusedAt: undefined,
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
        case FallbackStrategy.FIRST:
          active = 0;
          break;
        case FallbackStrategy.LAST:
          active = reused.length - 1;
          break;
        case FallbackStrategy.SAME_INDEX:
          active = Math.min(this.#active ?? 0, reused.length - 1);
          break;
      }
    }

    this.#items = reused;
    if (active) {
      this.activateAt(active);
    }
  }
}
