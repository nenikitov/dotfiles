#!/bin/env python
# TODO Check if works and implement

import argparse
import json
import os
import socket
import subprocess

PARSER = argparse.ArgumentParser()
PARSER.add_argument('-m', '--monitor', help='Current monitor', type=str, default=None)
ARGS = PARSER.parse_args()

HYPRLAND_INSTANCE = os.getenv('HYPRLAND_INSTANCE_SIGNATURE')
MONITOR = ARGS.monitor

def get(monitor: str | None = None):
    workspaces = json.loads(subprocess.check_output([
        'hyprctl', 'workspaces', '-j'
    ]))
    workspaces = [
        { 'id': w['id'], 'name': w['name'], 'windows': w['windows'] }
        for w in workspaces
        if monitor == None or monitor == w['monitor']
    ]
    print(json.dumps(workspaces), flush=True)


get(MONITOR)

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect(f"/tmp/hypr/{HYPRLAND_INSTANCE}/.socket2.sock")
while True:
    data = sock.recv(4096)
    if data:
        get(MONITOR)
