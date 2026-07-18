import { type OutputInfo } from "shoji_wm";
import { type Window } from "./window";
import { clamp } from "../../util/math";

const gaps = 8;

export class Output {
  public readonly info: OutputInfo;

  public windows: Window[];
  public activeIndex: number | null;

  constructor(info: OutputInfo) {
    this.info = info;
    this.windows = [];
    this.activeIndex = null;
  }

  public windowFocus(offset: number) {
    if (this.activeIndex === null) {
      return;
    }

    this.activeIndex = clamp(
      this.activeIndex + offset,
      0,
      this.windows.length - 1,
    );

    this.computeLayout();
  }

  public windowClose() {
    if (this.activeIndex === null) {
      return;
    }
    this.windows[this.activeIndex].info.close();
  }

  public windowAdd(window: Window) {
    this.windows.push(window);
    window.parent = this;

    if (this.activeIndex === null) {
      this.activeIndex = 0;
    }

    this.computeLayout();
  }

  public windowRemove(windowId: string): Window | null {
    const index = this.windows.findIndex(
      (window) => window.info.id === windowId,
    );
    if (index < 0) {
      return null;
    }

    const [window] = this.windows.splice(index, 1);
    window.parent = null;

    if (this.windows.length === 0) {
      this.activeIndex = null;
    } else if (this.activeIndex !== null) {
      if (index < this.activeIndex) {
        this.activeIndex -= 1;
      } else if (this.activeIndex >= this.windows.length) {
        this.activeIndex = this.windows.length - 1;
      }
    }

    this.computeLayout();

    return window;
  }

  public computeLayout() {
    if (!this.info.resolution || this.activeIndex === null) {
      return;
    }

    const tileStride = this.info.resolution.width / 2;
    const tileOffset = gaps / 2;
    const tileWidth = tileStride - gaps;
    const tileHeight = this.info.resolution.height - gaps;

    for (const [i, window] of this.windows.entries()) {
      window.rect = {
        x: i * tileStride + tileOffset,
        y: tileOffset,
        width: tileWidth,
        height: tileHeight,
      };
    }
  }

  public display() {
    if (!this.info.resolution || this.activeIndex === null) {
      return;
    }

    const offset = (this.windows[this.activeIndex].rect.x as number) - gaps;

    for (const window of this.windows) {
      window.display({
        x: (window.rect.x as number) - offset,
        y: window.rect.y,
        width: window.rect.width,
        height: window.rect.height,
      });
    }
  }
}
