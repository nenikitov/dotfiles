import Quickshell

import "modules/bar"

ShellRoot {
  Variants {
    model: Quickshell.screens

    Scope {
      required property ShellScreen modelData

      Bar {
        _screen: modelData
      }
    }
  }
}
