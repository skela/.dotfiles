//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData
      height: 26
      anchors { top: true; left: true; right: true }
      exclusionMode: ExclusionMode.Normal
      color: "#24273a"

      Bar {
        anchors.fill: parent
      }
    }
  }
}
