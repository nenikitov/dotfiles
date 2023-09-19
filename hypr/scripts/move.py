#!/bin/env python

import argparse
import subprocess
import json
import typing as t

class MoveParams(t.NamedTuple):
    direction: t.Literal['l', 'r', 'u', 'd']
    x: int
    y: int

def args() -> MoveParams:
    parser = argparse.ArgumentParser(description='Move windows using hyprctl based on floating status.')
    parser.add_argument('direction', choices=['l', 'r', 'u', 'd'], help='Direction for tiled')
    parser.add_argument('x', type=int, help='X-coordinate for floating')
    parser.add_argument('y', type=int, help='Y-coordinate for floating')
    return t.cast(MoveParams, parser.parse_args())

def main(args: MoveParams):
    direction = args.direction
    x = args.x
    y = args.y

    active_window = json.loads(
        subprocess.check_output(['hyprctl', 'activewindow', '-j'], text=True)
    )

    if active_window.get('floating', False):
        subprocess.run(['hyprctl', 'dispatch', f'moveactive {x} {y}'])
    else:
        subprocess.run(['hyprctl', 'dispatch', f'movewindow {direction}'])

if __name__ == '__main__':
    main(args())
