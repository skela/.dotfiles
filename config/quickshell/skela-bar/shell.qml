//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  property bool barVisible: true

  IpcHandler {
    target: "bar"
    function toggle(): void { barVisible = !barVisible }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      readonly property bool isPrimary: modelData.name === "DP-1"

      screen: modelData
      implicitHeight: isPrimary && barVisible ? 68 : 0
      exclusiveZone: isPrimary && barVisible ? 28 : 0
      anchors { top: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      color: "transparent"

      Rectangle {
        visible: isPrimary && barVisible
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 28
        color: "#050812"
        Bar { anchors.fill: parent }
      }
    }
  }
}
