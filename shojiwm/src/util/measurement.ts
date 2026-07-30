export class Sides<T> {
  public top: T;
  public right: T;
  public bottom: T;
  public left: T;

  public constructor(all: T);
  public constructor(x: T, y: T);
  public constructor(top: T, x: T, bottom: T);
  public constructor(top: T, right: T, bottom: T, left: T);
  public constructor(
    ...args:
      | [all: T]
      | [x: T, y: T]
      | [top: T, x: T, bottom: T]
      | [top: T, right: T, bottom: T, left: T]
  ) {
    switch (args.length) {
      case 1: {
        this.top = this.right = this.bottom = this.left = args[0];
        break;
      }
      case 2: {
        this.top = this.bottom = args[0];
        this.left = this.right = args[1];
        break;
      }
      case 3: {
        this.top = args[0];
        this.left = this.right = args[1];
        this.bottom = args[2];
        break;
      }
      case 4: {
        [this.top, this.right, this.bottom, this.left] = args;
        break;
      }
    }
  }
}
