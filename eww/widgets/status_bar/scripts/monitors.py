#!/bin/env python

import builtins
import json
import os
import socket
import subprocess
import typing as t



HYPRLAND_INSTANCE = os.getenv('HYPRLAND_INSTANCE_SIGNATURE')
WORKSPACE_NAMES = [
    '',
    '',
    '',
    '󰓃',
    '󰍡'
]

def print(*args, **kwargs):
    builtins.print(*args, **kwargs, flush=True)

def get():
    monitors: t.List[t.Dict] = json.loads(subprocess.check_output([
        'hyprctl', 'monitors', '-j'
    ]))
    monitors.sort(key=lambda m: m['id'])

    workspaces: t.List[t.Dict] = json.loads(subprocess.check_output([
        'hyprctl', 'workspaces', '-j'
    ]))
    workspaces.sort(key=lambda w: w['id'])

    output = []
    for m in monitors:
        workspaces_monitor = [ w for w in workspaces if w['monitor'] == m['name'] ]
        for i, n in enumerate(WORKSPACE_NAMES):
            i = i + 1
            if not any(w['id'] == i for w in workspaces_monitor):
                workspaces_monitor.append({
                    'id': i,
                    'name': n,
                    'windows': 0
                })
            else:
                for w in workspaces_monitor:
                    id = w['id'] - 1
                    if 0 <= id  < len(WORKSPACE_NAMES):
                        w['name'] = WORKSPACE_NAMES[id]
        workspaces_monitor.sort(key=lambda w: w['id'])
        workspaces_monitor = [
            {
                'id': w['id'],
                'name': w['name'],
                'windows': w['windows'],
                'active': w['id'] == m['activeWorkspace']['id']
            }
            for w in workspaces_monitor
        ]

        monitor_info = {
            'id': m['id'],
            'name': m['name'],
            'workspaces': workspaces_monitor,
            'focused': m['focused']
        }
        output.append(monitor_info)
    print(json.dumps(output, ensure_ascii=False))


get()

SOCK = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
SOCK.connect(f"/tmp/hypr/{HYPRLAND_INSTANCE}/.socket2.sock")
while True:
    data = SOCK.recv(4096)
    if data:
        get()
