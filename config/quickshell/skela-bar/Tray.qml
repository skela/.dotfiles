import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Row {
  id: root

  property int barHeight: 28
  property color fg: "#7a9ec0"
  property string barFont: "Roboto"

  spacing: 0

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
