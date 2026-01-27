import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: powerMenuRoot
    width: parent.width
    height: 22
    
    // Hover handler for the whole area including the popup
    HoverHandler {
        id: menuHover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    // Main Power Button (always visible)
    Text {
        id: powerIcon
        anchors.centerIn: parent
        text: "󰐥"
        color: "#dc2626" // Red color
        font.pixelSize: 17
    }

    // Expandable Options Container (appears to the right)
    Rectangle {
        id: optionsContainer
        anchors.left: parent.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 32
        width: menuHover.hovered ? (opRow.width + 16) : 0
        color: "#2a2520"
        border.color: "#d4a57440"
        border.width: 1
        radius: 16
        clip: true
        
        opacity: menuHover.hovered ? 1 : 0
        visible: opacity > 0
        
        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Row {
            id: opRow
            anchors.centerIn: parent
            spacing: 12
            
            // Re-anchor to ensure it stays centered as container grows
            anchors.verticalCenter: parent.verticalCenter
            
            // Suspend
            Text {
                text: "󰤄" // Sleep icon
                color: "#fbbf24" // Amber
                font.pixelSize: 16
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var proc = Qt.createQmlObject('import Quickshell; Process { command: ["systemctl", "suspend"] }', parent);
                        proc.running = true;
                    }
                    
                     // Simple hover effect
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Reboot
            Text {
                text: "󰑐" // Reboot icon
                color: "#3b82f6" // Blue
                font.pixelSize: 16
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var proc = Qt.createQmlObject('import Quickshell; Process { command: ["systemctl", "reboot"] }', parent);
                        proc.running = true;
                    }
                    
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Shutdown
            Text {
                text: "󰐥" // Power icon
                color: "#ef4444" // Red
                font.pixelSize: 16
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var proc = Qt.createQmlObject('import Quickshell; Process { command: ["systemctl", "poweroff"] }', parent);
                        proc.running = true;
                    }
                    
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }
}
