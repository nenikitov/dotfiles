import { assertType } from "./assert";
import { clamp } from "./math";

export class FocusListStrict<T> {
  private readonly inner: T[];
  private active: number | null;

  public constructor(items: T[] = []) {
    this.inner = items;
    this.active = items.length > 0 ? 0 : null;
  }

  public get items(): readonly T[] {
    return this.inner;
  }

  public get length(): number {
    return this.inner.length;
  }

  public getActive(method: "index"): number | null;
  public getActive(method: "object"): T | null;
  public getActive(method: "index" | "object"): number | T | null;
  public getActive(method: "index" | "object"): number | T | null {
    if (method == "index") {
      return this.active;
    } else {
      return this.active !== null ? this.inner[this.active] : null;
    }
  }

  public setActive(method: "first" | "last"): void;
  public setActive(method: "index", value: number): void;
  public setActive(method: "relative", value: number): void;
  public setActive(method: "object", value: T): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): void {
    if (this.inner.length === 0 || this.active === null) {
      return;
    }

    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(
          value,
          "When method is index, value is always a number",
        );
        target = value >= 0 ? value : value + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          value,
          "When method is relative, value is always a number",
        );
        target = this.active + value;
        break;
      }
      case "object": {
        assertType<T>(value, "When method is object, value is always T");
        const index = this.inner.indexOf(value);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target !== null) {
      this.active = Math.max(0, Math.min(this.inner.length - 1, target));
    }
  }

  public push(value: T, method: "first" | "last"): void;
  public push(value: T, method: "index", index: number): void;
  public push(value: T, method: "relative", index: number): void;
  public push(
    value: T,
    method: "first" | "last" | "index" | "relative",
    index?: number,
  ): void;
  public push(
    value: T,
    method: "first" | "last" | "index" | "relative",
    index?: number,
  ): void {
    let target: number = 0;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length;
        break;
      }
      case "index": {
        assertType<number>(
          index,
          "When method is index, index is always a number",
        );
        target = index >= 0 ? index : index + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          index,
          "When method is index, index is always a number",
        );
        target = (this.active ?? 0) + index;
        break;
      }
    }

    // Insert
    target = clamp(target, 0, this.length);
    this.inner.splice(target, 0, value);

    // Update active
    if (this.active === null) {
      this.active = 0;
    } else if (target <= this.active) {
      this.active = clamp(this.active + 1, 0, this.length - 1);
    }
  }

  public remove(method: "first" | "last"): T | null;
  public remove(method: "index", value: number): T | null;
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
    if (this.inner.length === 0 || this.active === null) {
      return null;
    }

    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(value);
        target = value >= 0 ? value : value + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(value);
        target = (this.active ?? 0) + value;
        break;
      }
      case "object": {
        assertType<T>(value);
        const index = this.inner.indexOf(value);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target === null || target < 0 || target >= this.length) {
      return null;
    }

    // Remove
    const [removed] = this.inner.splice(target, 1);

    // Update active
    if (this.inner.length === 0) {
      this.active = null;
    } else if (this.active !== null && target <= this.active) {
      this.active = clamp(this.active - 1, 0, this.length - 1);
    }

    return removed;
  }
}

export class FocusListDynamic<T> {
  private inner: FocusListStrict<T>;
  private readonly factory: () => T;
  private readonly canCleanup: (value: T) => boolean;

  public constructor(
    factory: () => T,
    canCleanup: (value: T) => boolean,
    items: T[] = [],
  ) {
    this.inner = new FocusListStrict(items);
    this.factory = factory;
    this.canCleanup = canCleanup;
    this.ensureCapacity();
  }

  public get items(): readonly T[] {
    return this.inner.items;
  }

  public get length(): number {
    return this.inner.length;
  }

  public getActive(method: "index"): number;
  public getActive(method: "object"): T;
  public getActive(method: "index" | "object"): number | T;
  public getActive(method: "index" | "object"): number | T {
    const result = this.inner.getActive(method);
    assertType<number | T>(
      result,
      "We always keep the length of the inner list at least 1 (ie has active)",
    );
    return result;
  }

  public setActive(method: "first" | "last"): void;
  public setActive(method: "index", value: number): void;
  public setActive(method: "relative", value: number): void;
  public setActive(method: "object", value: T): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T | null,
  ): void {
    let target: number | null = null;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length - 1;
        break;
      }
      case "index": {
        assertType<number>(
          value,
          "When method is index, value is always a number",
        );
        target = value >= 0 ? value : value + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          value,
          "When method is relative, value is always a number",
        );
        target = this.getActive("index") + value;
        break;
      }
      case "object": {
        assertType<T>(value, "When method is object, value is always T");
        const index = this.items.indexOf(value);
        target = index >= 0 ? index : null;
        break;
      }
    }

    if (target !== null) {
      this.ensureCapacity(target + 1);
      this.inner.setActive("index", target);
      this.cleanupTrailing();
    }
  }

  public push(value: T, method: "first" | "last"): void;
  public push(value: T, method: "index", index: number): void;
  public push(value: T, method: "relative", index: number): void;
  public push(
    value: T,
    method: "first" | "last" | "index" | "relative",
    index?: number,
  ): void;
  public push(
    value: T,
    method: "first" | "last" | "index" | "relative",
    index?: number,
  ): void {
    let target: number = 0;
    switch (method) {
      case "first": {
        target = 0;
        break;
      }
      case "last": {
        target = this.inner.length;
        break;
      }
      case "index": {
        assertType<number>(
          index,
          "When method is index, index is always a number",
        );
        target = index >= 0 ? index : index + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(
          index,
          "When method is index, index is always a number",
        );
        target = this.getActive("index") + index;
        break;
      }
    }
    target = clamp(target, 0);
    this.ensureCapacity(target);
    this.inner.push(value, "index", target);
    this.cleanupTrailing();
  }

  public remove(method: "first" | "last"): T;
  public remove(method: "index", value: number): T | null;
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
    const result = this.inner.remove(method, value);
    this.ensureCapacity();
    this.cleanupTrailing();
    return result;
  }

  private ensureCapacity(length: number = 1) {
    while (this.length < length) {
      this.inner.push(this.factory(), "last");
    }
  }

  private cleanupTrailing() {
    for (
      let i = this.length - 1;
      i > this.getActive("index") && this.length > 1;
      i--
    ) {
      if (this.canCleanup(this.items[i])) {
        this.inner.remove("index", i);
      } else {
        break;
      }
    }
  }
}
