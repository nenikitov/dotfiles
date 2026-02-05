import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower
import Quickshell.Widgets
import qs.components

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitWidth: layout.implicitWidth
  implicitHeight: layout.implicitHeight

  RowLayout {
    id: layout

    // Time
    Text {
      text: Qt.formatDateTime(clock.date, "hh:mm:ss\nyyyy-MM-dd")

      SystemClock {
        id: clock
      }
    }

    Icon {
      type: Icon.Type.Icon
      implicitSize: 22
      source: UPower.displayDevice.iconName
    }

    // Battery
    Text {
      text: UPower.displayDevice.percentage * 100
    }
  }
}
