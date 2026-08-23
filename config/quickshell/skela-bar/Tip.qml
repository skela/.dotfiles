import QtQuick

Rectangle {
  id: tip

  property string text: ""
  property Item hover: null

  visible: hover !== null && hover.containsMouse && text !== ""
  z: 999

  anchors.top: parent.bottom
  anchors.topMargin: 5
  anchors.horizontalCenter: parent.horizontalCenter

  color: "#0d1e30"
  border.color: "#00a8f8"
  border.width: 1
  radius: 5
  width: tipLabel.implicitWidth + 16
  height: tipLabel.implicitHeight + 10

  Text {
    id: tipLabel
    anchors.centerIn: parent
    text: tip.text
    color: "#d0e4f8"
    font.pixelSize: 12
    font.family: "sans-serif"
  }
}
