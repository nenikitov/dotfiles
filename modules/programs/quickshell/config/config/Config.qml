pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property string pathConfig: (
    Quickshell.env("XDG_CONFIG_HOME")
    || (Quickshell.env("HOME") + "/.config")
  ) + "/neshell"

  property alias bar: fileView.adapter

  FileView {
    id: fileView

    path: root.pathConfig + "/shell.json"

    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    JsonAdapter {
      property var bar: { "a": "b" }
    }
  }
}
