import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: powerMenuRoot
    width: parent.width
    height: 22
    
    // Hover handler for the icon area
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

    // Expandable Options Popup
    PopupWindow {
        id: optionsPopup
        
        anchor.window: powerMenuRoot
        
        // Position to the right of the icon
        anchor.onWidth: true
        anchor.rect.x: 10
        
        // Close on outside click
        width: opRow.width + 16
        height: 32
        
        color: "transparent"
        visible: menuHover.hovered || popupHover.hovered

        Rectangle {
            anchors.fill: parent
            color: "#2a2520"
            border.color: "#d4a57440"
            border.width: 1
            radius: 16
            
            HoverHandler {
                id: popupHover
            }

            Row {
                id: opRow
                anchors.centerIn: parent
                spacing: 12
                
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
}
