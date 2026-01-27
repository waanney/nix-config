import QtQuick
import QtQuick.Layouts

Item {
    id: workspacePositionArea
    Layout.fillWidth: true
    Layout.preferredHeight: 22
    property bool areaHovered: positionMouseArea.containsMouse
    
    Row {
    anchors.centerIn: parent
    spacing: 6
    
    // Workspace 1 indicator (active - darker beige/brown)
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: "#b89a7a" // Darker beige/brown active
    }
    
    // Workspace 2 indicator (inactive)
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: "#c4b5a0" // Light grey inactive
    }
    
    // Workspace 3 indicator (inactive)
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: "#c4b5a0" // Light grey inactive
    }
    }
    
    MouseArea {
    id: positionMouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    z: 5
    }
    
    // Hover tooltip
    Rectangle {
    anchors.left: parent.right
    anchors.leftMargin: 8
    anchors.verticalCenter: parent.verticalCenter
    width: hoverTooltip1.visible ? hoverTooltip1.width + 16 : 0
    height: hoverTooltip1.visible ? hoverTooltip1.height + 8 : 0
    color: "#2a2520"
    border.color: "#d4a57440"
    border.width: 1
    radius: 4
    visible: workspacePositionArea.areaHovered
    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }
    
    Text {
        id: hoverTooltip1
        anchors.centerIn: parent
        text: "Workspace 1: Column 1/3"
        color: "#e6e1dc"
        font.pixelSize: 10
        padding: 4
    }
    }
}
