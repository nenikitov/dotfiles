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
data = ''

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

    clients: t.List[t.Dict] = [ c for c in json.loads(subprocess.check_output([
        'hyprctl', 'clients', '-j'
    ])) if c['pid'] != -1 ]

    active_client: t.Dict = json.loads(subprocess.check_output([
        'hyprctl', 'activewindow', '-j'
    ]))

    output = []
    for m in monitors:
        monitor_workspaces = [ w for w in workspaces if w['monitor'] == m['name'] ]
        for i, n in enumerate(WORKSPACE_NAMES):
            i = i + 1
            if not any(w['id'] == i for w in monitor_workspaces):
                monitor_workspaces.append({
                    'id': i,
                    'name': n,
                    'windows': 0
                })
            else:
                for w in monitor_workspaces:
                    id = w['id'] - 1
                    if 0 <= id  < len(WORKSPACE_NAMES):
                        w['name'] = WORKSPACE_NAMES[id]
        monitor_workspaces.sort(key=lambda w: w['id'])
        monitor_workspaces = [
            {
                'id': w['id'],
                'name': w['name'],
                'client_count': w['windows'],
                'active': w['id'] == m['activeWorkspace']['id']
            }
            for w in monitor_workspaces
        ]

        monitor_info = {
            'id': m['id'],
            'name': m['name'],
            'workspaces': monitor_workspaces,
            'focused': m['focused'],
            'clients': [
                {
                    'hidden': c['hidden'],
                    'floating': c['floating'],
                    'class': c['class'],
                    'initial_class': c['initialClass'],
                    'title': c['title'],
                    'initial_title': c['initialTitle'],
                    'pid': c['pid'],
                    'pinned': c['pinned'],
                    'fullscreen': c['fullscreen'],
                    'grouped': c['grouped'],
                    'active': active_client['pid'] == c['pid']
                }
                for c in clients
                if m['id'] == c['monitor'] and m['activeWorkspace']['id'] == c['workspace']['id']
            ]
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
