import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
  id: root

  FontLoader {
    id: nfFont
    source: "file:///usr/share/fonts/TTF/JetBrainsMonoNerdFontMono-Regular.ttf"
  }

  // ── Colours ────────────────────────────────────────────────────────────
  readonly property color clrBg:      "#050812"
  readonly property color clrFg:      "#d0e4f8"
  readonly property color clrAccent:  "#00a8f8"
  readonly property color clrChipBg:  "#0a1428"
  readonly property color clrChipFg:  "#7a9ec0"
  readonly property color clrDim:     "#2d5070"
  readonly property color clrUrgent:  "#ff4060"
  readonly property color clrWarn:    "#e8a830"
  readonly property string barFont:   nfFont.name
  readonly property string wsFont:    "Font Awesome 7 Free Solid"

  // ── Window expansion ───────────────────────────────────────────────────
  property bool titleExpanded: false
  property string activeWindowTitle: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
  property string activeAppIcon: ""

  Process {
    id: iconLookupProcess
    command: ["/home/skela/.dotfiles/config/quickshell/skela-bar/find-icon.sh"]
    running: false
    stdout: SplitParser { onRead: data => iconLookupProcess.iconPath = data }
    property string iconPath: ""

    onExited: function(exitCode) {
      if (exitCode === 0 && iconPath) {
        activeAppIcon = "file://" + iconPath.trim()
      } else {
        activeAppIcon = ""
      }
      iconPath = ""
    }
  }

  function updateAppIcon() {
    if (!Hyprland.activeToplevel) {
      activeAppIcon = ""
      return
    }

    var ipc = Hyprland.activeToplevel.lastIpcObject
    var cls = ipc && ipc.class ? String(ipc.class) : ""

    if (!cls) {
      activeAppIcon = ""
      return
    }

    // Clear icon and start lookup
    activeAppIcon = ""
    iconLookupProcess.command = ["/home/skela/.dotfiles/config/quickshell/skela-bar/find-icon.sh", cls]
    iconLookupProcess.running = true
  }
  
  // Watch title changes to trigger icon update
  property string watchTitle: Hyprland.activeToplevel ? String(Hyprland.activeToplevel.title || "") : ""
  
  onWatchTitleChanged: {
    root.updateAppIcon()
  }
  
  Component.onCompleted: {
    root.updateAppIcon()
  }

  
  // Map common window classes to their icon paths
  function getIconPath(cls) {
    var iconMap = {
      "firefox-developer-edition": "/usr/share/icons/hicolor/128x128/apps/firefox-developer-edition.png",
      "com.mitchellh.ghostty": "/usr/share/icons/hicolor/128x128/apps/com.mitchellh.ghostty.png",
      "firefox": "/usr/share/icons/hicolor/128x128/apps/firefox.png",
      "chrome": "/usr/share/icons/hicolor/128x128/apps/google-chrome.png",
      "code": "/usr/share/icons/hicolor/128x128/apps/code.png",
      "org.kde.dolphin": "/usr/share/icons/hicolor/128x128/apps/org.kde.dolphin.png"
    }
    return iconMap[cls] || iconMap[cls.toLowerCase()] || ""
  }  // ── Clock ──────────────────────────────────────────────────────────────
  property date now: new Date()
  SystemClock {
    precision: SystemClock.Minutes
    onDateChanged: root.now = date
  }

  // ── Audio (Pipewire) ───────────────────────────────────────────────────
  readonly property var audioSink: Pipewire.defaultAudioSink
  readonly property bool audioMuted: audioSink && audioSink.audio ? audioSink.audio.muted : false
  readonly property int  audioVolume: audioSink && audioSink.audio
    ? Math.round(audioSink.audio.volume * 100) : 0
  PwObjectTracker { objects: root.audioSink ? [root.audioSink] : [] }

  // ── Screen recording ───────────────────────────────────────────────────
  property bool recording: false
  Process {
    id: recordProc
    command: ["pgrep", "-f", "^gpu-screen-recorder"]
    onExited: function(exitCode) { root.recording = (exitCode === 0) }
  }
  Timer {
    interval: 3000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!recordProc.running) recordProc.running = true }
  }

  // ── Idle inhibit ──────────────────────────────────────────────────────
  property bool idleInhibited: false
  Process {
    id: idleCheckProc
    command: ["bash", "-c", "[ -f \"$HOME/.cache/hypridle-inhibit\" ] && echo 1 || echo 0"]
    stdout: SplitParser { onRead: function(line) { root.idleInhibited = line.trim() === "1" } }
  }
  Timer {
    interval: 2000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!idleCheckProc.running) idleCheckProc.running = true }
  }
  Process {
    id: toggleIdleProc
    command: ["/home/skela/.config/hypr/scripts/toggle-idle-inhibit.sh"]
    onExited: function() { if (!idleCheckProc.running) idleCheckProc.running = true }
  }
  function toggleIdleInhibit() {
    root.idleInhibited = !root.idleInhibited
    if (!toggleIdleProc.running) toggleIdleProc.running = true
  }

  // ── Recording toggle ──────────────────────────────────────────────────
  Timer {
    id: recPollTimer
    interval: 800; repeat: true; running: false
    property int ticks: 0
    onTriggered: {
      if (!recordProc.running) recordProc.running = true
      ticks++
      if (ticks >= 5) { running = false; ticks = 0 }
    }
  }
  Process {
    id: toggleRecordProc
    command: ["bash", "-c", "setsid -f bash -c '/home/skela/.config/hypr/scripts/toggle-recording.sh </dev/null >/dev/null 2>&1'"]
    onExited: function() { recPollTimer.ticks = 0; recPollTimer.running = true }
  }
  function toggleRecording() {
    if (!toggleRecordProc.running) toggleRecordProc.running = true
  }

  // ── CPU/Memory/Temperature (polled) ───────────────────────────────────
  property int cpuPct: 0
  property int memPct: 0
  property int tempC:  0

  Process {
    id: sysProc
    command: ["bash", "-c",
      "cpu=$(python3 -c \"import time\nf=open('/proc/stat');l=f.readline().split();f.close()\nu1=int(l[1])+int(l[3]);t1=sum(int(x) for x in l[1:9])\ntime.sleep(0.4)\nf=open('/proc/stat');l=f.readline().split();f.close()\nu2=int(l[1])+int(l[3]);t2=sum(int(x) for x in l[1:9])\nprint(int((u2-u1)/(t2-t1)*100) if t2!=t1 else 0)\");" +
      "mem=$(free | awk '/Mem:/{printf \"%d\", $3/$2*100}');" +
      "tmp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0);" +
      "echo \"$cpu $mem $((tmp/1000))\""]
    stdout: SplitParser {
      onRead: function(line) {
        var parts = line.trim().split(" ")
        if (parts.length >= 3) {
          root.cpuPct = parseInt(parts[0]) || 0
          root.memPct = parseInt(parts[1]) || 0
          root.tempC  = parseInt(parts[2]) || 0
        }
      }
    }
  }
  Timer {
    interval: 4000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!sysProc.running) sysProc.running = true }
  }

  // ── Network ───────────────────────────────────────────────────────────
  property string netLabel: ""
  property string netIcon: ""
  property bool   netConnected: false

  Process {
    id: netProc
    command: ["bash", "-c",
      "line=$(nmcli -t -f DEVICE,TYPE,STATE dev status 2>/dev/null |" +
      " awk -F: '$3==\"connected\" {print $2 \"|\" $1; exit}');" +
      " iface=${line#*|}; type=${line%%|*};" +
      " ip=$(ip -4 addr show \"$iface\" 2>/dev/null | awk '/inet /{print $2; exit}');" +
      " echo \"$type|$iface|$ip\""]
    stdout: SplitParser {
      onRead: function(line) {
        var parts = line.trim().split("|")
        if (parts.length >= 2 && parts[0] !== "") {
          root.netConnected = true
          var icon = parts[0] === "wifi" ? "" : ""
          var iface = parts[1] || ""
          var ip    = parts[2] || ""
          root.netIcon  = icon
          root.netLabel = icon + " " + (ip ? iface + ":" + ip : iface)
        } else {
          root.netConnected = false
          root.netIcon  = ""
          root.netLabel = " Disconnected"
        }
      }
    }
    onExited: function(code) {
      if (code !== 0) {
        root.netConnected = false
        root.netIcon  = ""
        root.netLabel = " Disconnected"
      }
    }
  }
  Timer {
    interval: 5000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!netProc.running) netProc.running = true }
  }

  // ── Language ──────────────────────────────────────────────────────────
  property string kbLang: ""
  Process {
    id: kbToggleProc
    command: ["python3", "/home/skela/.dotfiles/scripts/toggle_keyboard_layout.py"]
    onExited: function() { if (!langProc.running) langProc.running = true }
  }
  Process {
    id: pavuProc
    command: ["pavucontrol"]
  }
  function toggleKeyboard() {
    if (!kbToggleProc.running) kbToggleProc.running = true
  }
  Process {
    id: langProc
    command: ["bash", "-c",
      "hyprctl devices -j 2>/dev/null | " +
      "python3 -c \"import sys,json; d=json.load(sys.stdin); " +
      "[print(k['active_keymap'][:2].upper()) for k in d.get('keyboards',[]) if k.get('main',False)]\" " +
      "2>/dev/null || echo ''"]
    stdout: SplitParser { onRead: function(line) { var s = line.trim(); if (s) root.kbLang = s } }
  }
  Timer {
    interval: 3000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!langProc.running) langProc.running = true }
  }

  // ── Pacman updates ────────────────────────────────────────────────────
  property int pacmanUpdates: 0
  Process {
    id: pacmanProc
    command: ["bash", "-c", "checkupdates 2>/dev/null | wc -l"]
    stdout: SplitParser { onRead: function(line) { root.pacmanUpdates = parseInt(line.trim()) || 0 } }
  }
  Timer {
    interval: 300000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { if (!pacmanProc.running) pacmanProc.running = true }
  }

  // ── Clipboard launch ──────────────────────────────────────────────────
  Process { id: clipProc }
  function openClipboard() {
    clipProc.command = ["kitty", "--class", "floating", "-e", "fish", "-c", "clipse $fish_pid"]
    if (!clipProc.running) clipProc.running = true
  }
  function clearClipboard() {
    clipProc.command = ["clipse", "-clear"]
    if (!clipProc.running) clipProc.running = true
  }

  // ── Notifications (swaync) ────────────────────────────────────────────
  property bool notifPanelOpen: false
  Process { id: notifToggle; command: ["bash", "-c", "sleep 0.1 && swaync-client -t -sw"] }
  Process { id: notifDnd;    command: ["swaync-client", "-d", "-sw"] }

  // ── MPRIS: first active player ─────────────────────────────────────────
  readonly property var mprisPlayer: {
    var players = Mpris.players ? Mpris.players.values : []
    for (var i = 0; i < players.length; i++) {
      if (players[i].playbackState !== MprisPlaybackState.Stopped) return players[i]
    }
    return players.length > 0 ? players[0] : null
  }
  readonly property bool mprisPlaying: mprisPlayer !== null
    && mprisPlayer.playbackState === MprisPlaybackState.Playing

  // ── Workspace helpers ─────────────────────────────────────────────────
  readonly property var wsIcons: ({
    1: "", 2: "", 3: "", 4: "", 5: "",
    6: "", 7: "", 8: "", 9: "", 10: ""
  })

  readonly property var wsIds: {
    var ids = [1,2,3,4,5,6,7,8,9,10]
    return ids
  }

  function workspaceById(id) {
    var vals = Hyprland.workspaces.values
    for (var i = 0; i < vals.length; i++) {
      if (vals[i].id === id) return vals[i]
    }
    return null
  }

  function switchWorkspace(id) {
    Hyprland.dispatch("hl.dsp.focus({workspace=" + id + "})")
  }

  // ── Layout ─────────────────────────────────────────────────────────────
  Item {
    anchors { fill: parent; leftMargin: 4; rightMargin: 4 }

    // ── Left: Workspaces ─────────────────────────────────────────────────
    Row {
      id: wsRow
      anchors { left: parent.left; verticalCenter: parent.verticalCenter }
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

          width: 26; height: 22

          Rectangle {
            anchors.centerIn: parent
            width: 22; height: 20
            radius: 5
            color: parent.focused ? "#071526" : (wsMouse.containsMouse ? "#0e1e3a" : "#0a1428")
            border.color: parent.focused ? root.clrAccent : "transparent"
            border.width: parent.focused ? 1 : 0
          }

          Text {
            anchors.centerIn: parent
            text: root.wsIcons[parent.modelData] || String(parent.modelData)
            color: parent.focused ? root.clrAccent : root.clrDim
            font.family: root.wsFont
            font.pixelSize: 14
            opacity: parent.occupied || parent.focused ? 1.0 : 0.4
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

    // ── Center: MPRIS + window title ─────────────────────────────────────
    Item {
      id: centerArea
      anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
      width: Math.min(centerRow.implicitWidth, parent.width - wsRow.implicitWidth - rightRow.implicitWidth - 16)
      height: 24
      clip: false

      Row {
        id: centerRow
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        spacing: 6

        // Window title
        Text {
          id: titleText
          anchors.verticalCenter: parent.verticalCenter
          visible: Hyprland.activeToplevel !== null && Hyprland.activeToplevel.title !== ""
          text: {
            var t = Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
            if (t.length > 36) t = t.slice(0, 35) + "\u2026"
            return t
          }
          color: root.clrChipFg
          font.family: root.barFont
          font.pixelSize: 12

          MouseArea {
            id: titleMouse
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.titleExpanded = true
            onExited: root.titleExpanded = false
          }


        }

        // MPRIS chip
        Rectangle {
          visible: root.mprisPlayer !== null
          width: visible ? mprisText.implicitWidth + 18 : 0; height: 24
          radius: 6; color: root.clrChipBg

          Text {
            id: mprisText
            anchors.centerIn: parent
            text: {
              if (!root.mprisPlayer) return ""
              var icon = root.mprisPlaying ? "\u25B6" : "\u23F8"
              var title = root.mprisPlayer.trackTitle || ""
              var artist = root.mprisPlayer.trackArtist || ""
              var label = title || artist
              if (label.length > 28) label = label.slice(0, 27) + "\u2026"
              return icon + (label ? "  " + label : "")
            }
            color: root.clrChipFg
            font.family: root.barFont
            font.pixelSize: 12
          }

          MouseArea {
            id: mprisMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor
            onEntered: root.titleExpanded = true
            onExited: root.titleExpanded = false
            onClicked: function(mouse) {
              if (!root.mprisPlayer) return
              if (mouse.button === Qt.LeftButton) root.mprisPlayer.togglePlaying()
              else if (mouse.button === Qt.RightButton) root.mprisPlayer.next()
              else if (mouse.button === Qt.MiddleButton) root.mprisPlayer.previous()
            }
          }

          Tip {
            hover: mprisMouse
            text: root.mprisPlayer ? ((root.mprisPlayer.trackTitle || "") + (root.mprisPlayer.trackArtist ? " — " + root.mprisPlayer.trackArtist : "")) : ""
          }
        }
      }
    }

    // ── Right: chips ──────────────────────────────────────────────────────
    Row {
      id: rightRow
      anchors { right: parent.right; verticalCenter: parent.verticalCenter }
      height: 24
      spacing: 2

      // Recording
      Rectangle {
        width: recRow.implicitWidth + 18; height: 24
        radius: 6
        color: root.recording ? "#060e1e" : root.clrChipBg
        border.color: root.recording ? Qt.rgba(0, 0.659, 0.973, 0.28) : "transparent"
        border.width: 1

        Row {
          id: recRow
          anchors.centerIn: parent
          height: 18
          spacing: root.recording ? 4 : 0
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.recording ? "" : ""
            color: root.recording ? root.clrUrgent : root.clrChipFg
            font.family: root.wsFont; font.pixelSize: 15
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            visible: root.recording
            text: "Recording"
            color: root.clrAccent
            font.family: root.barFont; font.pixelSize: 13
          }
        }

        MouseArea {
          anchors.fill: parent; cursorShape: Qt.PointingHandCursor
          onClicked: root.toggleRecording()
        }
      }

      // Idle inhibit
            Rectangle {
        id: idleChip
        width: 30; height: 24
        radius: 6; color: root.clrChipBg
        Text {
          anchors.centerIn: parent
          text: root.idleInhibited ? "󰛐" : "󰒲"
          color: root.idleInhibited ? root.clrAccent : root.clrChipFg
          font.family: root.barFont
          font.pixelSize: 18
        }
        MouseArea {
          anchors.fill: parent; cursorShape: Qt.PointingHandCursor
          onClicked: root.toggleIdleInhibit()
        }
      }

      // Clipboard
            Rectangle {
        id: clipChip
        width: 30; height: 24
        radius: 6; color: root.clrChipBg
        Text {
          anchors.centerIn: parent
          text: ""
          color: root.clrChipFg
          font.family: root.barFont
          font.pixelSize: 18
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          cursorShape: Qt.PointingHandCursor
          onClicked: function(mouse) {
            if (mouse.button === Qt.MiddleButton) root.clearClipboard()
            else root.openClipboard()
          }
        }
      }

      // Network
      Rectangle {
        id: netChip
        property bool expanded: false
        width: netChipRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: netChipRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.netIcon
            color: root.netConnected ? root.clrChipFg : root.clrUrgent
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            visible: netChip.expanded
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.netLabel.replace(root.netIcon, "").trim()
            color: root.netConnected ? root.clrChipFg : root.clrUrgent
            font.family: root.barFont; font.pixelSize: 13
          }
        }

        MouseArea {
          id: netMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: netChip.expanded = !netChip.expanded
        }

        Tip { hover: netMouse; text: root.netLabel }
      }

      // Volume
      Rectangle {
        width: volRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: volRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: {
              if (root.audioMuted) return ""
              var v = root.audioVolume
              return v === 0 ? "" : (v < 30 ? "" : (v < 70 ? "" : ""))
            }
            color: root.audioMuted ? root.clrDim : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.audioVolume + "%"
            color: root.audioMuted ? root.clrDim : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }

        MouseArea {
          id: volMouse
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          cursorShape: Qt.PointingHandCursor
          onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
              if (!pavuProc.running) pavuProc.running = true
            } else {
              if (root.audioSink && root.audioSink.audio)
                root.audioSink.audio.muted = !root.audioSink.audio.muted
            }
          }
          onWheel: function(wheel) {
            if (!root.audioSink || !root.audioSink.audio) return
            var delta = wheel.angleDelta.y > 0 ? 0.03 : -0.03
            root.audioSink.audio.volume = Math.max(0, Math.min(1.5, root.audioSink.audio.volume + delta))
          }
        }

        Tip {
          hover: volMouse
          text: (root.audioMuted ? "Muted — " : "") + root.audioVolume + "% · scroll to adjust"
        }
      }

      // CPU
      Rectangle {
        width: cpuRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: cpuRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: ""
            color: root.cpuPct > 85 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.cpuPct + "%"
            color: root.cpuPct > 85 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }
      }

      // Memory
      Rectangle {
        width: memRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: memRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: ""
            color: root.memPct > 85 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.memPct + "%"
            color: root.memPct > 85 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }
      }

      // Temperature
      Rectangle {
        width: tempRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: tempRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.tempC < 50 ? "" : (root.tempC < 70 ? "" : "")
            color: root.tempC >= 80 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.tempC + "\u00B0C"
            color: root.tempC >= 80 ? root.clrUrgent : root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }
      }

      // Language
      Rectangle {
        visible: root.kbLang !== ""
        width: langRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: langRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: ""
            color: root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.kbLang
            color: root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.toggleKeyboard()
        }
      }

      // Pacman updates
      Rectangle {
        visible: root.pacmanUpdates > 0
        width: pacRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: pacRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: ""
            color: root.clrAccent
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: root.pacmanUpdates + ""
            color: root.clrAccent
            font.family: root.barFont; font.pixelSize: 13
          }
        }
      }

      // System tray
      Tray {
        barHeight: 22
        fg: root.clrChipFg
        barFont: root.barFont
      }

      // Clock
      Rectangle {
        width: clockRow.implicitWidth + 18; height: 24
        radius: 6; color: root.clrChipBg

        Row {
          id: clockRow
          anchors.centerIn: parent
          height: 18
          spacing: 4
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: ""
            color: root.clrChipFg
            font.family: root.barFont; font.pixelSize: 18
          }
          Text {
            height: 18; verticalAlignment: Text.AlignVCenter
            text: Qt.formatDateTime(root.now, "dd/MM - HH:mm")
            color: root.clrChipFg
            font.family: root.barFont; font.pixelSize: 13
          }
        }
      }

      // Notifications
            Rectangle {
        id: bellChip
        width: 30; height: 24
        radius: 6; color: root.clrChipBg
        Text {
          anchors.centerIn: parent
          text: ""
          color: root.clrChipFg
          font.family: root.barFont
          font.pixelSize: 18
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          cursorShape: Qt.PointingHandCursor
          onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
              if (!notifDnd.running) notifDnd.running = true
            } else {
              if (!notifToggle.running) notifToggle.running = true
            }
          }
        }
      }

    } // Row right
  } // Item



  // Bottom border
  Rectangle {
    anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
    height: 1
    color: Qt.rgba(0, 0.659, 0.973, 0.18)
  }
}
