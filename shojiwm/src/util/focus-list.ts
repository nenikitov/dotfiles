import { assertType } from "./assert";

export class FocusList<T> {
  private readonly inner: T[] = [];
  private active: number | null = null;

  public get items(): readonly T[] {
    return this.inner;
  }

  public getActive(method: "index"): number | null;
  public getActive(method: "object"): T | null;
  public getActive(method: "index" | "object" = "index"): number | T | null {
    if (method == "index") {
      return this.active;
    } else {
      return this.active !== null ? this.inner[this.active] : null;
    }
  }

  public setActive(method: "first" | "last"): void;
  public setActive(method: "index", value: number | null): void;
  public setActive(method: "relative", value: number | null): void;
  public setActive(method: "object", value: T | null): void;
  public setActive(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T | null,
  ): void {
    if (value === null || this.inner.length === 0) {
      this.active = null;
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
        assertType<number | null>(value);
        target = value >= 0 ? value : value + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number | null>(value);
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

    this.active =
      target !== null
        ? Math.max(0, Math.min(this.inner.length - 1, target))
        : null;
  }

  public push(value: T, method: "first" | "last"): void;
  public push(value: T, method: "index", index: number): void;
  public push(value: T, method: "relative", index: number): void;
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
        assertType<number>(index);
        target = index >= 0 ? index : index + this.inner.length;
        break;
      }
      case "relative": {
        assertType<number>(index);
        target = (this.active ?? 0) + index;
        break;
      }
    }

    // Insert
    target = this.clampIndex(target);
    this.inner.splice(target, 0, value);

    // Update active
    if (this.active === null) {
      this.active = 0;
    } else if (target <= this.active) {
      this.active = this.clampIndex(this.active + 1);
    }
  }

  public remove(method: "first" | "last"): T | null;
  public remove(method: "index", value: number): T | null;
  public remove(method: "relative", value: number): T | null;
  public remove(method: "object", value: T): T | null;
  public remove(
    method: "first" | "last" | "index" | "relative" | "object",
    value?: number | T,
  ): T | null {
    if (this.inner.length === 0) {
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

    if (target === null) {
      return null;
    }

    // Remove
    const [removed] = this.inner.splice(target, 1);

    // Update active
    if (this.inner.length === 0) {
      this.active = null;
    } else if (this.active !== null && target <= this.active) {
      this.active = this.clampIndex(this.active - 1);
    }

    return removed;
  }

  private clampIndex(index: number): number {
    return Math.max(0, Math.min(this.inner.length, index));
  }
}
