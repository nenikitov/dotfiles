import Quickshell
import Quickshell.Widgets
import QtQuick

Loader {
  enum Type {
    Raw,
    Icon,
    Nerd
  }

  id: root

  property int type: Icon.Type.Raw
  required property string source

  property int implicitSize: 22

  readonly property Component iconImage: IconImage {
    source: root.type == Icon.Type.Icon ? Quickshell.iconPath(root.source) : root.source
    implicitSize: root.implicitSize
  }
  readonly property Component iconText: Text {
    text: root.source

    width: root.implicitSize
    height: root.implicitSize
    font.pointSize: root.implicitSize / 2

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  sourceComponent: type == Icon.Type.Nerd ? iconText : iconImage
}
