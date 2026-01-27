import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: batteryItem
    width: parent.width
    height: 22
    property bool itemHovered: batteryMouseArea.containsMouse
    
    Text {
        id: batteryText
        anchors.centerIn: parent
        color: "#5a5650"
        font.pixelSize: 17
        text: "󰁹"
        
        Component.onCompleted: {
        const proc = Qt.createQmlObject(`
            import Quickshell
            Process {
            command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1 || echo '0'"]
            running: true
            interval: 5000
            }
        `, batteryText);
        proc.onStdout = (data) => {
            const capacity = parseInt(data.trim());
            if (capacity >= 90) {
            batteryText.text = "󰁹";
            } else if (capacity >= 70) {
            batteryText.text = "󰂀";
            } else if (capacity >= 50) {
            batteryText.text = "󰁾";
            } else if (capacity >= 30) {
            batteryText.text = "󰁻";
            } else if (capacity >= 10) {
            batteryText.text = "󰁺";
            } else {
            batteryText.text = "󰁹";
            }
        };
        }
    }
    
    MouseArea {
        id: batteryMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 5
    }
    
    // Battery tooltip
    Rectangle {
        anchors.left: parent.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: batteryTooltip.visible ? batteryTooltip.width + 16 : 0
        height: batteryTooltip.visible ? batteryTooltip.height + 8 : 0
        color: "#2a2520"
        border.color: "#d4a57440"
        border.width: 1
        radius: 4
        visible: batteryItem.itemHovered
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        
        Column {
        id: batteryTooltip
        anchors.centerIn: parent
        spacing: 2
        padding: 4
        
        Text {
            text: "Battery: 85%"
            color: "#e6e1dc"
            font.pixelSize: 10
        }
        Text {
            text: "Charging"
            color: "#c4b5a0"
            font.pixelSize: 9
        }
        }
    }
}
