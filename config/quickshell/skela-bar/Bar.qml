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
  readonly property color clrChipBg:  "transparent"  // Removed background
  readonly property color clrChipFg:  "#7a9ec0"
  readonly property color clrDim:     "#2d5070"
  readonly property color clrUrgent:  "#ff4060"
  readonly property color clrWarn:    "#e8a830"
  readonly property string barFont:   nfFont.name
  readonly property string wsFont:    "Font Awesome 7 Free Solid"

  // ── Window expansion ───────────────────────────────────────────────────
  property bool titleExpanded: false
  property bool overlayHovered: false
  onOverlayHoveredChanged: { if (overlayHovered) collapseTimer.stop() }

  Timer {
    id: collapseTimer
    interval: 200
    repeat: false
    onTriggered: { if (!root.overlayHovered) root.titleExpanded = false }
  }

  function hoverEnter() {
    collapseTimer.stop()
    titleExpanded = true
  }
  function hoverExit() {
    collapseTimer.restart()
  }  property string activeWindowTitle: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
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
    id: pavuControlProc
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
  property alias notifToggle: notifToggleProc
  property alias notifDnd: notifDndProc
  property alias pavuProc: pavuControlProc
  Process { id: notifToggleProc; command: ["bash", "-c", "sleep 0.1 && swaync-client -t -sw"] }
  Process { id: notifDndProc;    command: ["swaync-client", "-d", "-sw"] }

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

  Process {
    id: wsSwitchProc
    property int targetId: 0
    command: ["/home/skela/.dotfiles/config/hypr/scripts/qtile_like_swap.sh", String(targetId)]
  }

  function switchWorkspace(id) {
    wsSwitchProc.targetId = id
    if (!wsSwitchProc.running) wsSwitchProc.running = true
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

          Text {
            anchors.centerIn: parent
            text: root.wsIcons[parent.modelData] || String(parent.modelData)
            color: parent.focused ? root.clrAccent : root.clrChipFg
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

    // ── Center: Clock ─────────────────────────────────────────────────────
    Item {
      id: centerArea
      anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
      width: centerClockRow.implicitWidth + 18
      height: 24

      Row {
        id: centerClockRow
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        spacing: 4
        Text {
          height: 18; verticalAlignment: Text.AlignVCenter
          text: ""
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

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hoverEnter()
        onExited: root.hoverExit()
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

      // System tray toggle + tray
      property bool trayVisible: false

      Tray {
        visible: rightRow.trayVisible
        barHeight: 22
        fg: root.clrChipFg
        barFont: root.barFont
      }

      Rectangle {
        width: 24; height: 24
        radius: 6; color: rightRow.trayVisible ? Qt.rgba(0, 0.659, 0.973, 0.12) : root.clrChipBg
        border.color: rightRow.trayVisible ? Qt.rgba(0, 0.659, 0.973, 0.3) : "transparent"
        border.width: 1
        Text {
          anchors.centerIn: parent
          text: "\uF069"
          color: rightRow.trayVisible ? root.clrAccent : root.clrChipFg
          font.family: "JetBrainsMono Nerd Font Mono"
          font.pixelSize: 16
        }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: rightRow.trayVisible = !rightRow.trayVisible
        }
      }

      // Notifications
      Rectangle {
        width: 30; height: 24
        radius: 6; color: root.clrChipBg
        Text {
          anchors.centerIn: parent
          text: "\uF0F3"
          color: root.clrChipFg
          font.family: "JetBrainsMono Nerd Font Mono"
          font.pixelSize: 18
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          cursorShape: Qt.PointingHandCursor
          onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
              if (!root.notifDnd.running) root.notifDnd.running = true
            } else {
              if (!root.notifToggle.running) root.notifToggle.running = true
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
