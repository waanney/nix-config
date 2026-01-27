import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: bluetoothItem
    width: parent.width
    height: 22
    property bool itemHovered: bluetoothMouseArea.containsMouse
    
    Text {
        id: bluetoothText
        anchors.centerIn: parent
        color: "#5a5650"
        font.pixelSize: 17
        text: "󰂯"
    }
    
    MouseArea {
        id: bluetoothMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 5
    }
}
