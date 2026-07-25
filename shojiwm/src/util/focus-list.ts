import { clamp } from "./math";

export interface Item<T> {
  item: T;
  focusTime: Date | null;
}

export class FocusListStrict<T> {
  readonly #inner: Item<T>[];
  #active: number | null;

  public constructor(items: T[] = []) {
    this.#inner = items.map((item) => ({ item, focusTime: null }));
    this.#active = null;

    if (this.length > 0) {
      this.activateAt(0);
    }
  }

  public get items(): readonly Item<T>[] {
    return this.#inner;
  }
  public get length(): number {
    return this.#inner.length;
  }

  public get activeIndex(): number | null {
    return this.#active;
  }

  public get activeObject(): Item<T> | null {
    return this.#active !== null ? this.#inner[this.#active] : null;
  }

  public activateAt(index: number): boolean {
    if (this.length === 0 || this.#active === null) {
      return false;
    }

    const target = index >= 0 ? index : index + this.#inner.length;
    if (target < 0 || target >= this.length) {
      return false;
    }

    this.#active = target;
    this.items[this.#active].focusTime = new Date();
    return true;
  }

  public activateFirst(): boolean {
    return this.activateAt(0);
  }

  public activateLast(): boolean {
    return this.activateAt(this.length - 1);
  }

  public activateRelative(offset: number): boolean {
    if (this.#active === null) return false;
    return this.activateAt(clamp(this.#active + offset, 0, this.length - 1));
  }

  public activateObject(value: T): boolean {
    const index = this.#inner.findIndex((item) => item.item === value);
    if (index < 0) {
      return false;
    }
    return this.activateAt(index);
  }

  public insertAt(index: number, ...values: T[]): T[] | false {
    const target = index >= 0 ? index : index + this.length;

    if (target < 0 || target > this.length) {
      return false;
    }

    const items = values.map((item) => ({ item, focusTime: null }));
    this.#inner.splice(target, 0, ...items);

    if (this.#active === null) {
      this.activateAt(0);
    } else if (target <= this.#active) {
      this.activateAt(clamp(this.#active + values.length, 0, this.length - 1));
    }

    return values;
  }

  public insertFirst(...values: T[]): T[] {
    return this.insertAt(0, ...values) as T[];
  }

  public insertLast(...values: T[]): T[] {
    return this.insertAt(this.length, ...values) as T[];
  }

  public insertRelative(offset: number, ...values: T[]): T[] {
    return this.insertAt(
      clamp((this.#active ?? 0) + offset, 0, this.length),
      ...values,
    ) as T[];
  }

  public removeAt(index: number): Item<T> | null {
    if (this.length === 0 || this.#active === null) {
      return null;
    }
    const target = index >= 0 ? index : index + this.#inner.length;

    if (target < 0 || target >= this.length) {
      return null;
    }

    const [removed] = this.#inner.splice(target, 1);

    if (this.#inner.length === 0) {
      this.#active = null;
    } else if (target <= this.#active) {
      this.#active = clamp(this.#active - 1, 0, this.length - 1);
    }

    return removed;
  }

  public removeFirst(): Item<T> | null {
    return this.removeAt(0);
  }

  public removeLast(): Item<T> | null {
    return this.removeAt(this.length - 1);
  }

  public removeRelative(offset: number): Item<T> | null {
    return this.removeAt((this.#active ?? 0) + offset);
  }

  public removeObject(value: T): Item<T> | null {
    const index = this.#inner.findIndex((item) => item.item === value);
    if (index < 0) {
      return null;
    }
    return this.removeAt(index);
  }

  public rebuild(items: T[] = []) {
    this.#inner.splice(
      0,
      this.#inner.length,
      ...items.map((item) => ({ item, focusTime: null })),
    );
    this.#active = null;

    if (this.length > 0) {
      this.activateAt(0);
    }
  }
}

/*
export class FocusListDynamic<T> {
  #inner: FocusListStrict<T>;
  readonly #factory: () => T;
  readonly #canCleanup: (value: T) => boolean;

  public constructor(
    factory: () => T,
    canCleanup: (value: T) => boolean,
    items: T[] = [],
  ) {
    this.#inner = new FocusListStrict(items);
    this.#factory = factory;
    this.#canCleanup = canCleanup;
    this.#ensureCapacity();
  }

  public get items(): readonly T[] {
    return this.#inner.items;
  }
  public get length(): number {
    return this.#inner.length;
  }

  public get activeIndex(): number {
    return this.#inner.activeIndex!;
  }

  public get activeObject(): T {
    return this.#inner.activeObject!;
  }

  public activateAt(index: number): boolean {
    const target = index >= 0 ? index : index + this.#inner.length;

    if (target < 0) {
      return false;
    }

    this.#ensureCapacity(target + 1);
    this.#inner.activateAt(target);
    this.#cleanupTrailing();

    return true;
  }

  public activateFirst(): boolean {
    return this.activateAt(0);
  }
  public activateLast(): boolean {
    return this.activateAt(this.length - 1);
  }

  public activateRelative(offset: number): boolean {
    return this.activateAt(this.activeIndex + offset);
  }

  public activateObject(value: T): boolean {
    const index = this.items.indexOf(value);
    if (index < 0) {
      return false;
    }
    return this.activateAt(index);
  }

  public insertAt(index: number, ...values: T[]): T[] | false {
    const target = index >= 0 ? index : index + this.length;

    if (target < 0) {
      return false;
    }

    this.#ensureCapacity(target);
    const result = this.#inner.insertAt(target, ...values);
    this.#cleanupTrailing();
    return result;
  }

  public insertFirst(...values: T[]): T[] {
    return this.insertAt(0, ...values) as T[];
  }
  public insertLast(...values: T[]): T[] {
    return this.insertAt(this.length, ...values) as T[];
  }
  public insertRelative(offset: number, ...values: T[]): T[] {
    return this.insertAt(
      clamp(this.activeIndex + offset, 0, this.length),
      ...values,
    ) as T[];
  }

  public removeAt(index: number): T | null {
    const result = this.#inner.removeAt(index);
    this.#ensureCapacity();
    this.#cleanupTrailing();
    return result;
  }

  public removeFirst(): T | null {
    return this.removeAt(0);
  }
  public removeLast(): T | null {
    return this.removeAt(this.length - 1);
  }
  public removeRelative(offset: number): T | null {
    return this.removeAt(this.activeIndex + offset);
  }
  public removeObject(value: T): T | null {
    return this.removeAt(this.items.indexOf(value));
  }

  public rebuild(items: T[] = []) {
    this.#inner.rebuild(items);
    this.#ensureCapacity();
    this.#inner.activateFirst();
  }

  #ensureCapacity(length: number = 1) {
    while (this.length < length) {
      this.#inner.insertLast(this.#factory());
    }
  }

  #cleanupTrailing() {
    for (
      let i = this.length - 1;
      i > this.activeIndex && this.length > 1;
      i--
    ) {
      if (this.#canCleanup(this.items[i])) {
        this.#inner.removeAt(i);
      } else {
        break;
      }
    }
  }
}
*/
