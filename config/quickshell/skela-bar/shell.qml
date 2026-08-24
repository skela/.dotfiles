//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  property bool barVisible: true
  property string hostname: ""

  Process {
    command: ["hostname"]
    running: true
    stdout: SplitParser {
      onRead: data => hostname = data.trim()
    }
  }

  IpcHandler {
    target: "bar"
    function toggle(): void { barVisible = !barVisible }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      readonly property string primaryScreen: hostname === "dark" ? "DP-4" : "DP-1"
      readonly property bool isPrimary: modelData.name === primaryScreen

      screen: modelData
      implicitHeight: isPrimary && barVisible ? (barItem.titleExpanded ? 168 : 28) : 0
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
        height: 140
        color: "#050812"

        // Keep panel open while hovered, and allow clicks
        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
          onEntered: barItem.expandHoverCount++
          onExited: barItem.expandHoverCount--
        }

        Rectangle {
          anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
          height: 1
          color: "#00a8f8"
        }

        // ── Top section: window info + MPRIS ─────────────────────────────
        // Window info - centered when no MPRIS, otherwise right-aligned
        Row {
          visible: barItem.activeWindowTitle !== ""
          anchors {
            horizontalCenter: barItem.mprisPlayer !== null ? undefined : parent.horizontalCenter
            right: barItem.mprisPlayer !== null ? parent.horizontalCenter : undefined
            rightMargin: barItem.mprisPlayer !== null ? 20 : 0
            top: parent.top; topMargin: 12
          }
          spacing: 16

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: barItem.activeWindowTitle
            color: "#d0e4f8"
            font.family: "sans-serif"
            font.pixelSize: 14
            width: Math.min(implicitWidth, 500)
            elide: Text.ElideRight
          }

          Rectangle {
            width: 56; height: 56
            color: "transparent"
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

        // MPRIS info - left-aligned from center
        Row {
          id: mprisInfoRow
          visible: barItem.mprisPlayer !== null
          anchors {
            left: parent.horizontalCenter
            leftMargin: 20
            top: parent.top; topMargin: 12
          }
          spacing: 16

          Rectangle {
            width: 56; height: 56
            color: "transparent"
            radius: 6

            Image {
              id: albumArt
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

            // Click album art to toggle play/pause
            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              z: 20
              onClicked: { if (barItem.mprisPlayer) barItem.mprisPlayer.togglePlaying() }
            }
          }

          Column {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(400, 600)

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

            // Play/pause · prev · next buttons
            Row {
              spacing: 16

              Text {
                text: "⏮"
                color: "#7a9ec0"
                font.pixelSize: 16
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: { if (barItem.mprisPlayer) barItem.mprisPlayer.previous() }
                }
              }

              Text {
                text: barItem.mprisPlaying ? "⏸" : "▶"
                color: "#00a8f8"
                font.pixelSize: 16
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: { if (barItem.mprisPlayer) barItem.mprisPlayer.togglePlaying() }
                }
              }

              Text {
                text: "⏭"
                color: "#7a9ec0"
                font.pixelSize: 16
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: { if (barItem.mprisPlayer) barItem.mprisPlayer.next() }
                }
              }
            }
          }
        }

        // ── Bottom stats strip ────────────────────────────────────────────
        Rectangle {
          anchors { bottom: parent.bottom; bottomMargin: 1; left: parent.left; right: parent.right }
          height: 28
          color: Qt.rgba(0, 0.04, 0.1, 0.6)

          Row {
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            spacing: 2

            // Volume
            Rectangle {
              width: volOverlayRow.implicitWidth + 16; height: 22
              radius: 5; color: "transparent"
              Row {
                id: volOverlayRow
                anchors.centerIn: parent
                spacing: 5
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: "VOL"
                  color: "#2d5070"
                  font.family: "sans-serif"; font.pixelSize: 10; font.bold: true
                }
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: barItem.audioMuted ? "muted" : (barItem.audioVolume + "%")
                  color: barItem.audioMuted ? "#2d5070" : "#7a9ec0"
                  font.family: "sans-serif"; font.pixelSize: 12
                }
              }
              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: function(mouse) {
                  if (mouse.button === Qt.RightButton) {
                    if (!barItem.pavuProc.running) barItem.pavuProc.running = true
                  } else {
                    if (barItem.audioSink && barItem.audioSink.audio)
                      barItem.audioSink.audio.muted = !barItem.audioSink.audio.muted
                  }
                }
                onWheel: function(wheel) {
                  if (!barItem.audioSink || !barItem.audioSink.audio) return
                  var delta = wheel.angleDelta.y > 0 ? 0.03 : -0.03
                  barItem.audioSink.audio.volume = Math.max(0, Math.min(1.5, barItem.audioSink.audio.volume + delta))
                }
              }
            }

            Text { text: "·"; color: "#1a3050"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }

            // CPU
            Rectangle {
              width: cpuOverlayRow.implicitWidth + 16; height: 22
              radius: 5; color: "transparent"
              Row {
                id: cpuOverlayRow
                anchors.centerIn: parent
                spacing: 5
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: "CPU"
                  color: barItem.cpuPct > 85 ? "#7a1020" : "#2d5070"
                  font.family: "sans-serif"; font.pixelSize: 10; font.bold: true
                }
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: barItem.cpuPct + "%"
                  color: barItem.cpuPct > 85 ? "#ff4060" : "#7a9ec0"
                  font.family: "sans-serif"; font.pixelSize: 12
                }
              }
            }

            Text { text: "·"; color: "#1a3050"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }

            // RAM
            Rectangle {
              width: memOverlayRow.implicitWidth + 16; height: 22
              radius: 5; color: "transparent"
              Row {
                id: memOverlayRow
                anchors.centerIn: parent
                spacing: 5
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: "RAM"
                  color: barItem.memPct > 85 ? "#7a1020" : "#2d5070"
                  font.family: "sans-serif"; font.pixelSize: 10; font.bold: true
                }
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: barItem.memPct + "%"
                  color: barItem.memPct > 85 ? "#ff4060" : "#7a9ec0"
                  font.family: "sans-serif"; font.pixelSize: 12
                }
              }
            }

            Text { text: "·"; color: "#1a3050"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }

            // Temperature
            Rectangle {
              width: tempOverlayRow.implicitWidth + 16; height: 22
              radius: 5; color: "transparent"
              Row {
                id: tempOverlayRow
                anchors.centerIn: parent
                spacing: 5
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: "TEMP"
                  color: barItem.tempC >= 80 ? "#7a1020" : "#2d5070"
                  font.family: "sans-serif"; font.pixelSize: 10; font.bold: true
                }
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: barItem.tempC + "°C"
                  color: barItem.tempC >= 80 ? "#ff4060" : "#7a9ec0"
                  font.family: "sans-serif"; font.pixelSize: 12
                }
              }
            }

            Text { text: "·"; color: "#1a3050"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }

            // Network
            Rectangle {
              width: netOverlayRow.implicitWidth + 16; height: 22
              radius: 5; color: "transparent"
              Row {
                id: netOverlayRow
                anchors.centerIn: parent
                spacing: 5
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: "NET"
                  color: barItem.netConnected ? "#2d5070" : "#7a1020"
                  font.family: "sans-serif"; font.pixelSize: 10; font.bold: true
                }
                Text {
                  height: 16; verticalAlignment: Text.AlignVCenter
                  text: barItem.netConnected ? barItem.netLabel.replace(barItem.netIcon, "").trim() : "disconnected"
                  color: barItem.netConnected ? "#7a9ec0" : "#ff4060"
                  font.family: "sans-serif"; font.pixelSize: 12
                }
              }
            }
          }

          // (no bell here — moved back to bar)
        }
      }
    }
  }
}
