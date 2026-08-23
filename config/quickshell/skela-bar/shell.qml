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
      implicitHeight: isPrimary && barVisible ? (barItem.titleExpanded ? 140 : 28) : 0
      exclusiveZone: isPrimary && barVisible ? 28 : 0
      anchors { top: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      color: "transparent"

      Behavior on implicitHeight { enabled: false }

      Rectangle {
        visible: isPrimary && barVisible
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 28
        color: "#050812"
        Bar {
          id: barItem
          anchors.fill: parent
        }
      }

      // Combined info expansion
      Rectangle {
        visible: isPrimary && barVisible && barItem.titleExpanded
        anchors { top: parent.top; topMargin: 28; left: parent.left; right: parent.right }
        height: 112
        color: "#050812"

        Rectangle {
          anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
          height: 1
          color: "#00a8f8"
        }

        Row {
          anchors { fill: parent; margins: 20 }
          spacing: 40

          // Window info - right-aligned from center
          Item {
            width: parent.width / 2 - 20
            height: parent.height

            Row {
              visible: barItem.activeWindowTitle !== ""
              anchors { right: parent.right; verticalCenter: parent.verticalCenter }
              spacing: 16

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: barItem.activeWindowTitle
                color: "#d0e4f8"
                font.family: "sans-serif"
                font.pixelSize: 14
                width: Math.min(implicitWidth, parent.parent.width - 80)
                elide: Text.ElideRight
              }

              Rectangle {
                width: 56; height: 56
                color: "#0a1428"
                radius: 6

                Text {
                  anchors.centerIn: parent
                  text: barItem.activeWindowTitle !== "" ? barItem.activeWindowTitle.charAt(0).toUpperCase() : "?"
                  color: "#00a8f8"
                  font.family: "sans-serif"
                  font.pixelSize: 24
                  font.bold: true
                }

                Image {
                  anchors.centerIn: parent
                  width: 48; height: 48
                  source: barItem.activeAppIcon
                  fillMode: Image.PreserveAspectFit
                  sourceSize.width: 48
                  sourceSize.height: 48
                  visible: true
                  z: 10
                }
              }
            }
          }

          // MPRIS info - left-aligned from center
          Item {
            width: parent.width / 2 - 20
            height: parent.height

            Row {
              visible: barItem.mprisPlayer !== null
              anchors { left: parent.left; verticalCenter: parent.verticalCenter }
              spacing: 16

              Rectangle {
                width: 56; height: 56
                color: "#0a1428"
                radius: 6

                Image {
                  anchors.centerIn: parent
                  width: 48; height: 48
                  source: barItem.mprisPlayer && barItem.mprisPlayer.trackArtUrl ? barItem.mprisPlayer.trackArtUrl : ""
                  fillMode: Image.PreserveAspectCrop
                  sourceSize.width: 56
                  sourceSize.height: 56
                  onStatusChanged: {
                    if (status === Image.Error || status === Image.Null) {
                      visible = false
                    }
                  }

                  Rectangle {
                    anchors.centerIn: parent
                    width: 24; height: 24
                    color: "transparent"
                    visible: !parent.visible || parent.status !== Image.Ready

                    Text {
                      anchors.centerIn: parent
                      text: barItem.mprisPlaying ? "▶" : "⏸"
                      color: "#00a8f8"
                      font.pixelSize: 20
                    }
                  }
                }
              }

              Column {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(parent.parent.width - 80, 400)

                Text {
                  text: barItem.mprisPlayer ? (barItem.mprisPlayer.trackTitle || "Unknown") : ""
                  color: "#d0e4f8"
                  font.family: "sans-serif"
                  font.pixelSize: 14
                  width: parent.width
                  elide: Text.ElideRight
                }

                Text {
                  text: barItem.mprisPlayer ? (barItem.mprisPlayer.trackArtist || "") : ""
                  color: "#7a9ec0"
                  font.family: "sans-serif"
                  font.pixelSize: 12
                  width: parent.width
                  elide: Text.ElideRight
                }
              }
            }
          }
        }
      }
    }
  }
}
