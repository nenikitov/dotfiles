#!/usr/bin/env gjs

import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import {
    Box,
    Button,
    Stack,
    Label,
    Icon,
    CenterBox,
    Window,
    Slider,
    ProgressBar,
} from "resource:///com/github/Aylur/ags/widget.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

import * as config from "./user.js";

const Workspaces = () =>
    Box({
        className: "workspaces",
        connections: [
            [
                Hyprland,
                (box) => {
                    const arr = Array.from({ length: 10 }, (_, i) => i + 1);
                    box.children = arr.map((i) =>
                        Button({
                            onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
                            child: Label({ label: `${i}` }),
                            className: Hyprland.active.workspace.id == i ? "focused" : "",
                        })
                    );
                },
            ],
        ],
    });

const Left = () =>
    Box({
        children: [Workspaces(), Label({ label: "hello" })],
    });

const Bar = ({ monitor } = {}) =>
    Window({
        name: `bar${monitor || ""}`,
        className: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusive: true,
        child: Left(),
    });

export default {
    windows: [Bar()],
};
