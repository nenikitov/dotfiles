export class Axis {
  public static readonly HORIZONTAL = new Axis();
  public static readonly VERTICAL = new Axis();

  private constructor() {}

  public get perpendicular(): Axis {
    return this == Axis.HORIZONTAL ? Axis.VERTICAL : Axis.HORIZONTAL;
  }

  public get directions(): Direction[] {
    return this == Axis.HORIZONTAL
      ? [Direction.LEFT, Direction.RIGHT]
      : [Direction.UP, Direction.DOWN];
  }
}

export class Direction {
  public static readonly LEFT = new Direction();
  public static readonly UP = new Direction();
  public static readonly RIGHT = new Direction();
  public static readonly DOWN = new Direction();

  private constructor() {}

  public get axis(): Axis {
    return Axis.HORIZONTAL.directions.includes(this)
      ? Axis.HORIZONTAL
      : Axis.VERTICAL;
  }

  public get opposite(): Direction {
    if (this == Direction.LEFT) {
      return Direction.RIGHT;
    } else if (this == Direction.RIGHT) {
      return Direction.LEFT;
    } else if (this == Direction.UP) {
      return Direction.DOWN;
    } else {
      return Direction.UP;
    }
  }
}
