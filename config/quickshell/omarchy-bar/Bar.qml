import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
  id: root

  // Catppuccin Macchiato
  readonly property color clrFg: "#cad3f5"
  readonly property color clrAccent: "#8aadf4"
  readonly property color clrUrgent: "#ed8796"
  readonly property string barFont: "Maple Mono NF"

  // ── Clock ──────────────────────────────────────────────────────────────
  property date now: new Date()
  SystemClock {
    precision: SystemClock.Minutes
    onDateChanged: root.now = date
  }

  // ── Microphone ─────────────────────────────────────────────────────────
  readonly property var micSource: Pipewire.defaultAudioSource
  readonly property bool micMuted: micSource && micSource.audio ? micSource.audio.muted : true
  readonly property bool micInUse: {
    var nodes = Pipewire.nodes ? Pipewire.nodes.values : []
    for (var i = 0; i < nodes.length; i++) {
      var n = nodes[i]
      if (n && n.isStream && n.isSink === false && !(n.audio && n.audio.muted)) return true
    }
    return false
  }
  PwObjectTracker { objects: root.micSource ? [root.micSource] : [] }

  // ── Screen recording ───────────────────────────────────────────────────
  property bool recording: false
  Process {
    id: recordProc
    command: ["pgrep", "-f", "^gpu-screen-recorder"]
    onExited: function(exitCode) { root.recording = (exitCode === 0) }
  }
  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: { if (!recordProc.running) recordProc.running = true }
  }

  // ── Workspace switching via hyprctl ────────────────────────────────────
  Process {
    id: wsProc
  }
  function switchWorkspace(id) {
    if (wsProc.running) return
    wsProc.command = ["hyprctl", "dispatch", "workspace", String(id)]
    wsProc.running = true
  }

  // ── Workspace IDs (always show 1-5 plus any extras) ────────────────────
  readonly property var wsIds: {
    var ids = [1, 2, 3, 4, 5]
    var vals = Hyprland.workspaces.values
    for (var i = 0; i < vals.length; i++) {
      var wid = vals[i].id
      if (wid > 0 && wid <= 10 && ids.indexOf(wid) < 0) ids.push(wid)
    }
    ids.sort(function(a, b) { return a - b })
    return ids
  }

  function workspaceById(id) {
    var vals = Hyprland.workspaces.values
    for (var i = 0; i < vals.length; i++) {
      if (vals[i].id === id) return vals[i]
    }
    return null
  }

  // ── Layout ─────────────────────────────────────────────────────────────
  RowLayout {
    anchors { fill: parent; leftMargin: 4; rightMargin: 4 }
    spacing: 0

    // Left: Workspaces
    Row {
      Layout.alignment: Qt.AlignVCenter
      spacing: 2

      Repeater {
        model: root.wsIds

        delegate: Item {
          required property int modelData

          readonly property bool focused: Hyprland.focusedWorkspace !== null
            && Hyprland.focusedWorkspace.id === modelData
          readonly property var ws: root.workspaceById(modelData)
          readonly property bool occupied: ws !== null
            && ws.toplevels !== undefined
            && ws.toplevels.values.length > 0

          width: 24
          height: 26

          Rectangle {
            anchors.centerIn: parent
            width: 20
            height: 20
            radius: 4
            color: parent.focused
              ? Qt.rgba(0.541, 0.678, 0.957, 0.22)
              : (wsMouse.containsMouse ? Qt.rgba(0.541, 0.678, 0.957, 0.08) : "transparent")
          }

          Text {
            anchors.centerIn: parent
            text: parent.focused
              ? "󱓻"
              : (parent.modelData === 10 ? "0" : String(parent.modelData))
            color: parent.focused ? root.clrAccent : root.clrFg
            font.family: root.barFont
            font.pixelSize: 11
            opacity: parent.occupied || parent.focused ? 1.0 : 0.5
          }

          MouseArea {
            id: wsMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.switchWorkspace(parent.modelData)
          }
        }
      }
    }

    // Center: Clock (expands to fill remaining space)
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(root.now, "ddd d MMM  HH:mm")
        color: root.clrFg
        font.family: root.barFont
        font.pixelSize: 12
      }
    }

    // Right: indicators + tray
    Row {
      Layout.alignment: Qt.AlignVCenter
      spacing: 0

      // Recording indicator (only shown when recording)
      Item {
        visible: root.recording
        width: 21
        height: 26
        Text {
          anchors.centerIn: parent
          text: "󰻂"
          color: root.clrUrgent
          font.family: root.barFont
          font.pixelSize: 13
        }
      }

      // Microphone indicator
      Item {
        visible: root.micSource !== null
        width: 21
        height: 26
        Text {
          anchors.centerIn: parent
          text: root.micMuted ? "󰍭" : "󰍬"
          color: root.micInUse ? root.clrAccent : root.clrFg
          font.family: root.barFont
          font.pixelSize: 13
          opacity: root.micMuted ? 0.45 : 1.0
        }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          hoverEnabled: true
          onClicked: {
            if (root.micSource && root.micSource.audio)
              root.micSource.audio.muted = !root.micSource.audio.muted
          }
        }
      }

      // System tray
      Tray {
        barHeight: 26
        fg: root.clrFg
        barFont: root.barFont
      }
    }
  }
}
