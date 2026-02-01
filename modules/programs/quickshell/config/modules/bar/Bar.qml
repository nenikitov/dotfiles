import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

PanelWindow {
  required property ShellScreen _screen

  screen: _screen

  anchors {
    top: true
    left: true
    right: true
  }

  implicitWidth: layout.implicitWidth
  implicitHeight: layout.implicitHeight

  RowLayout {
    id: layout
    anchors.fill: parent

    // Time
    Text {
      text: Qt.formatDateTime(clock.date, "hh:mm:ss\nyyyy-MM-dd")

      SystemClock {
        id: clock
      }
    }

    // Battery
    Text {
      text: UPower.displayDevice.percentage
    }
  }
}
