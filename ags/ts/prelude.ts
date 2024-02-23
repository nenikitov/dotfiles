// App
import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk";
import App from "resource:///com/github/Aylur/ags/app.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import Greetd from "resource:///com/github/Aylur/ags/service/greetd.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import PowerProfiles from "resource:///com/github/Aylur/ags/service/powerprofiles.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";
import Service from "resource:///com/github/Aylur/ags/service.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

import type Window from "types/widgets/window";

const service = {
  Applications,
  Audio,
  Battery,
  Bluetooth,
  Greetd,
  Hyprland,
  Mpris,
  Network,
  Notifications,
  PowerProfiles,
  Service,
  SystemTray,
};

export { App, Gdk, Gtk, Utils, Variable, Widget, Window, service as Service };
