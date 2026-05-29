import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    height: 28
    implicitWidth: clockRow.width + 20
    radius: 14
    color: "#181825"
    border.color: clockMouse.hovered ? theme.overlay : theme.surface
    border.width: 1
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    
    Behavior on border.color { ColorAnimation { duration: 150 } }

    property var theme
    property var sysInfo: { "uptime": "0h 0m" }
    
    signal pillClicked(real xCoord, string type)
    signal pillEntered()
    signal pillExited()

    RowLayout {
        id: clockRow
        anchors.centerIn: parent
        spacing: 8

        // Calendar Icon & Date
        RowLayout {
            spacing: 4
            Text {
                text: "󰸗"
                color: theme.lavender
                font.pixelSize: 12
                font.family: theme.fontFamily
            }
            Text {
                id: dateLabel
                color: theme.subtext
                font.pixelSize: 11
                font.family: theme.fontFamily
                text: Qt.formatDateTime(new Date(), "ddd, MMM d")
            }
        }

        // Splitter dot
        Rectangle {
            width: 4
            height: 4
            radius: 2
            color: theme.surface
            Layout.alignment: Qt.AlignVCenter
        }

        // Clock Icon & Time
        RowLayout {
            spacing: 4
            Text {
                text: "󱑒"
                color: theme.mauve
                font.pixelSize: 12
                font.family: theme.fontFamily
            }
            Text {
                id: clockLabel
                color: theme.text
                font.pixelSize: 12
                font.bold: true
                font.family: theme.fontFamily
                text: clockMouse.hovered ? Qt.formatDateTime(new Date(), "HH:mm:ss") : Qt.formatDateTime(new Date(), "HH:mm");
            }
        }
    }

    MouseArea {
        id: clockMouse
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: {
            root.pillEntered();
        }
        
        onClicked: {
            var pos = parent.mapToItem(null, 0, 0);
            root.pillClicked(pos.x + parent.width / 2, "clock");
        }
        
        onExited: {
            root.pillExited();
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clockLabel.text = clockMouse.hovered ? Qt.formatDateTime(new Date(), "HH:mm:ss") : Qt.formatDateTime(new Date(), "HH:mm");
                dateLabel.text = Qt.formatDateTime(new Date(), "ddd, MMM d");
            }
        }
    }
}
