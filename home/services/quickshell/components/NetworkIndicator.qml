import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: wifiItem
    width: parent.width
    height: 22
    property bool itemHovered: wifiMouseArea.containsMouse
    
    Text {
        id: networkText
        anchors.centerIn: parent
        color: "#5a5650"
        font.pixelSize: 17
        text: "󰤨"
        
        Component.onCompleted: {
        const proc = Qt.createQmlObject(`
            import Quickshell
            Process {
            command: ["sh", "-c", "cat /sys/class/net/wl*/operstate 2>/dev/null | grep -q 'up' && echo 'up' || echo 'down'"]
            running: true
            interval: 5000
            }
        `, networkText);
        proc.onStdout = (data) => {
            if (data.trim() === "up") {
            networkText.text = "󰤨";
            } else {
            networkText.text = "󰤭";
            }
        };
        }
    }
    
    MouseArea {
        id: wifiMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 5
    }
    
    // WiFi tooltip
    Rectangle {
        anchors.left: parent.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: wifiTooltip.visible ? wifiTooltip.width + 16 : 0
        height: wifiTooltip.visible ? wifiTooltip.height + 8 : 0
        color: "#2a2520"
        border.color: "#d4a57440"
        border.width: 1
        radius: 4
        visible: wifiItem.itemHovered
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        
        Column {
        id: wifiTooltip
        anchors.centerIn: parent
        spacing: 2
        padding: 4
        
        Text {
            text: "Connected to: Network"
            color: "#e6e1dc"
            font.pixelSize: 10
        }
        Text {
            text: "Strength: 67/100"
            color: "#c4b5a0"
            font.pixelSize: 9
        }
        Text {
            text: "Frequency: 5500 MHz"
            color: "#c4b5a0"
            font.pixelSize: 9
        }
        }
    }
}
