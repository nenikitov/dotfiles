import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

Loader {
  enum Type {
    Raw,
    Icon,
    Nerd
  }

  id: root

  property int type: Icon.Type.Icon
  required property string source
  property color color: null

  property int implicitSize: 22

  readonly property Component innerImage: IconImage {
    id: image

    source: root.type == Icon.Type.Icon ? Quickshell.iconPath(root.source) : root.source
    implicitSize: root.implicitSize

    // TODO: Add colorization
    layer.enabled: false
    layer.effect: MultiEffect { }
  }
  readonly property Component innerText: Text {
    text: root.source

    color: root.color

    width: root.implicitSize
    height: root.implicitSize
    font.pointSize: root.implicitSize / 2

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  sourceComponent: type == Icon.Type.Nerd ? innerText : innerImage
}
