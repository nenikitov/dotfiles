import { assertType } from "./assert";
import { clamp } from "./math";

export class FocusListStrict<T> {
  readonly #inner: T[];
  #active: number | null;

  public constructor(items: T[] = []) {
    this.#inner = items;
    this.#active = items.length > 0 ? 0 : null;
  }

  public get items(): readonly T[] {
    return this.#inner;
  }

  public get length(): number {
    return this.#inner.length;
  }

  public getActive(method: "index"): number | null;
  public getActive(method: "object"): T | null;
  public getActive(method: "index" | "object"): number | T | null;
  public getActive(method: "index" | "object"): number | T | null {
    if (method == "index") {
      return this.#active;
    } else {
      return this.#active !== null ? this.#inner[this.#active] : null;
    }
  }

  public setActive(method: "first" | "last"): void;
  public setActive(method: "index", index: number): void;
  public setActive(method: "relative", index: number): void;
  public setActive(method: "object", value: T): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): void {
    if (this.#inner.length === 0 || this.#active === null) {
      return;
    }

    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.#inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(
          indexOrValue,
          "When method is index, value is always a number",
        );
        target =
          indexOrValue >= 0 ? indexOrValue : indexOrValue + this.#inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          indexOrValue,
          "When method is relative, value is always a number",
        );
        target = this.#active + indexOrValue;
        break;
      }
      case "object": {
        assertType<T>(indexOrValue, "When method is object, value is always T");
        const index = this.#inner.indexOf(indexOrValue);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target !== null) {
      this.#active = Math.max(0, Math.min(this.#inner.length - 1, target));
    }
  }

  public push(...args: [method: "first" | "last", ...values: T[]]): T[];
  public push(...args: [method: "index", index: number, ...values: T[]]): T[];
  public push(
    ...args: [method: "relative", index: number, ...values: T[]]
  ): T[];
  public push(
    ...args:
      | [method: "first" | "last", ...values: T[]]
      | [method: "index" | "relative", index: number, ...values: T[]]
  ): T[];
  public push(
    ...args:
      | [method: "first" | "last", ...values: T[]]
      | [method: "index" | "relative", index: number, ...values: T[]]
  ): T[] {
    const [method, ...rest] = args;

    let target: number = 0;
    let values: T[] = [];

    switch (method) {
      case "first": {
        target = 0;
        values = rest as T[];
        break;
      }
      case "last": {
        target = this.#inner.length;
        values = rest as T[];
        break;
      }
      case "index": {
        assertType<number>(
          rest[0],
          "When method is index, index is always a number",
        );
        target = rest[0] >= 0 ? rest[0] : rest[0] + this.#inner.length;
        values = rest.slice(1) as T[];
        break;
      }
      case "relative": {
        assertType<number>(
          rest[0],
          "When method is index, index is always a number",
        );
        target = (this.#active ?? 0) + rest[0];
        values = rest.slice(1) as T[];
        break;
      }
    }

    // Insert
    target = clamp(target, 0, this.length);
    this.#inner.splice(target, 0, ...values);

    // Update active
    if (this.#active === null) {
      this.#active = 0;
    } else if (target <= this.#active) {
      this.#active = clamp(this.#active + values.length, 0, this.length - 1);
    }

    return values;
  }

  public remove(method: "first" | "last"): T | null;
  public remove(method: "index", index: number): T | null;
  public remove(method: "relative", value: number): T | null;
  public remove(method: "object", value: T): T | null;
  public remove(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): T | null;
  public remove(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): T | null {
    if (this.#inner.length === 0 || this.#active === null) {
      return null;
    }

    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.#inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(indexOrValue);
        target =
          indexOrValue >= 0 ? indexOrValue : indexOrValue + this.#inner.length;
        break;
      }
      case "relative": {
        assertType<number>(indexOrValue);
        target = (this.#active ?? 0) + indexOrValue;
        break;
      }
      case "object": {
        assertType<T>(indexOrValue);
        const index = this.#inner.indexOf(indexOrValue);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target === null || target < 0 || target >= this.length) {
      return null;
    }

    // Remove
    const [removed] = this.#inner.splice(target, 1);

    // Update active
    if (this.#inner.length === 0) {
      this.#active = null;
    } else if (this.#active !== null && target <= this.#active) {
      this.#active = clamp(this.#active - 1, 0, this.length - 1);
    }

    return removed;
  }

  public rebuild(items: T[] = []) {
    this.#inner.splice(0, this.#inner.length, ...items);
    this.#active = items.length > 0 ? 0 : null;
  }
}

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

  public getActive(method: "index"): number;
  public getActive(method: "object"): T;
  public getActive(method: "index" | "object"): number | T;
  public getActive(method: "index" | "object"): number | T {
    const result = this.#inner.getActive(method);
    assertType<number | T>(
      result,
      "We always keep the length of the inner list at least 1 (ie has active)",
    );
    return result;
  }

  public setActive(method: "first" | "last"): void;
  public setActive(method: "index", index: number): void;
  public setActive(method: "relative", index: number): void;
  public setActive(method: "object", value: T): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    indexOrValue?: number | T,
  ): void {
    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.#inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(
          indexOrValue,
          "When method is index, value is always a number",
        );
        target =
          indexOrValue >= 0 ? indexOrValue : indexOrValue + this.#inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          indexOrValue,
          "When method is relative, value is always a number",
        );
        target = this.getActive("index") + indexOrValue;
        break;
      }
      case "object": {
        assertType<T>(indexOrValue, "When method is object, value is always T");
        const index = this.items.indexOf(indexOrValue);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target !== null) {
      this.#ensureCapacity(target + 1);
      this.#inner.setActive("index", target);
      this.#cleanupTrailing();
    }
  }

  public push(...args: [method: "first" | "last", ...values: T[]]): T[];
  public push(...args: [method: "index", index: number, ...values: T[]]): T[];
  public push(
    ...args: [method: "relative", index: number, ...values: T[]]
  ): T[];
  public push(
    ...args:
      | [method: "first" | "last", ...values: T[]]
      | [method: "index" | "relative", index: number, ...values: T[]]
  ): T[];
  public push(
    ...args:
      | [method: "first" | "last", ...values: T[]]
      | [method: "index" | "relative", index: number, ...values: T[]]
  ): T[] {
    const [method, ...rest] = args;

    let target: number = 0;
    let values: T[] = [];

    switch (method) {
      case "first": {
        target = 0;
        values = rest as T[];
        break;
      }
      case "last": {
        target = this.#inner.length;
        values = rest as T[];
        break;
      }
      case "index": {
        assertType<number>(
          rest[0],
          "When method is index, index is always a number",
        );
        target = rest[0] >= 0 ? rest[0] : rest[0] + this.#inner.length;
        values = rest.slice(1) as T[];
        break;
      }
      case "relative": {
        assertType<number>(
          rest[0],
          "When method is index, index is always a number",
        );
        target = this.getActive("index") + rest[0];
        values = rest.slice(1) as T[];
        break;
      }
    }

    target = clamp(target, 0);
    this.#ensureCapacity(target);
    this.#inner.push("index", target, ...values);
    this.#cleanupTrailing();

    return values;
  }

  public remove(method: "first" | "last"): T;
  public remove(method: "index", index: number): T | null;
  public remove(method: "relative", value: number): T | null;
  public remove(method: "object", value: T): T | null;
  public remove(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): T | null;
  public remove(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): T | null {
    const result = this.#inner.remove(method, value);
    this.#ensureCapacity();
    this.#cleanupTrailing();
    return result;
  }

  public rebuild(items: T[] = []) {
    this.#inner.rebuild(items);
    this.#ensureCapacity();
    this.#inner.setActive("first");
  }

  #ensureCapacity(length: number = 1) {
    while (this.length < length) {
      this.#inner.push("last", this.#factory());
    }
  }

  #cleanupTrailing() {
    for (
      let i = this.length - 1;
      i > this.getActive("index") && this.length > 1;
      i--
    ) {
      if (this.#canCleanup(this.items[i])) {
        this.#inner.remove("index", i);
      } else {
        break;
      }
    }
  }
}
