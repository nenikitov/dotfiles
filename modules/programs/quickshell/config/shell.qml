//@ pragma IconTheme Fluent

import Quickshell
import QtQuick

import "modules/bar"

ShellRoot {
  Variants {
    model: Quickshell.screens

    Item {
      required property ShellScreen modelData

      Bar {
        screen: modelData
      }
    }
  }
}
