import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Row {
  id: root

  property int barHeight: 26
  property color fg: "#cad3f5"
  property string barFont: "monospace"

  spacing: 0

  // Reactive list of non-passive tray items
  readonly property var items: {
    var result = []
    var vals = SystemTray.items.values
    for (var i = 0; i < vals.length; i++) {
      if (vals[i].status !== Status.Passive) result.push(vals[i])
    }
    return result
  }

  Repeater {
    model: root.items

    delegate: Item {
      required property var modelData

      width: root.barHeight
      height: root.barHeight

      Image {
        anchors.centerIn: parent
        width: 16
        height: 16
        source: String(parent.modelData.icon || "")
        fillMode: Image.PreserveAspectFit
        sourceSize.width: Math.round(16 * Screen.devicePixelRatio)
        sourceSize.height: Math.round(16 * Screen.devicePixelRatio)
      }

      MouseArea {
        id: trayMouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
          if (mouse.button === Qt.MiddleButton) {
            parent.modelData.secondaryActivate()
          } else if (mouse.button === Qt.RightButton && parent.modelData.menu) {
            // UseQApplication pragma in shell.qml enables native platform menus
            var pt = parent.QsWindow.contentItem.mapFromItem(trayMouse, mouse.x, mouse.y)
            parent.modelData.display(parent.QsWindow.window, pt.x, pt.y)
          } else {
            parent.modelData.activate()
          }
        }
      }
    }
  }
}
