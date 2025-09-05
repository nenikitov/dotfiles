import typing as t

import argparse
import json
import subprocess


class MoveParams(argparse.Namespace):
    command: str
    x: t.Optional[str]
    y: t.Optional[str]


def args() -> MoveParams:
    parser = argparse.ArgumentParser(description='Move windows using `niri msg` based on floating status.')
    parser.add_argument('-c', '--command', help='Command to use if the window is tiled.', required=True)
    parser.add_argument('-x', '--x', help='X distance to move if the window if floating.')
    parser.add_argument('-y', '--y', help='Y distance to move if the window if floating.')
    return parser.parse_args(namespace=MoveParams())


def main(args: MoveParams):
    command = args.command
    x = args.x
    y = args.y

    active_window = json.loads(
        subprocess.check_output(['niri', 'msg', '--json', 'focused-window'], text=True)
    )

    if active_window.get('is_floating', False):
        subprocess.run([
            'niri',
            'msg',
            'action',
            'move-floating-window',
            *([] if x == None else ['--x', x]),
            *([] if y == None else ['--y', y]),
        ])
    else:
        subprocess.run(['niri', 'msg', 'action', command])


if __name__ == '__main__':
    main(args())
