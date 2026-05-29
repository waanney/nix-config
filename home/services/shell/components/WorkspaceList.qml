import QtQuick
import QtQuick.Layouts
import Quickshell

Row {
    id: root
    spacing: 6
    Layout.alignment: Qt.AlignVCenter

    property var workspaces: []
    property var theme

    // Helper functions
    function getWorkspaceIcon(name) {
        if (!name) return "●";
        var lower = name.toLowerCase();
        if (lower.indexOf("communication") !== -1) return "󰭹";
        if (lower.indexOf("development") !== -1) return "";
        if (lower.indexOf("browsing") !== -1) return "";
        if (lower.indexOf("media") !== -1) return "󰎆";
        return "●";
    }

    function getWorkspaceDisplayName(name) {
        if (!name) return "";
        var lower = name.toLowerCase();
        if (lower.indexOf("communication") !== -1) return "Chat";
        if (lower.indexOf("development") !== -1) return "Code";
        if (lower.indexOf("browsing") !== -1) return "Web";
        if (lower.indexOf("media") !== -1) return "Media";
        return name;
    }

    Repeater {
        model: root.workspaces
        delegate: Rectangle {
            id: wsItem
            width: modelData.is_focused ? 88 : 28
            height: 26
            radius: 13
            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
            
            color: modelData.is_focused 
                ? theme.mauve 
                : (modelData.active_window_id 
                    ? (wsMouse.hovered ? "#45475a" : "#1e1e2e") 
                    : "transparent")
            
            border.color: modelData.is_focused 
                ? "transparent" 
                : (modelData.active_window_id 
                    ? (wsMouse.hovered ? theme.subtext : theme.surface) 
                    : (wsMouse.hovered ? theme.subtext : theme.surface))
            border.width: 1
            
            Behavior on color { ColorAnimation { duration: 100 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            // Focused Workspace Layout
            RowLayout {
                anchors.centerIn: parent
                spacing: 4
                visible: modelData.is_focused

                Text {
                    text: getWorkspaceIcon(modelData.name)
                    color: theme.mantle
                    font.pixelSize: 13
                    font.family: theme.fontFamily
                }
                Text {
                    text: getWorkspaceDisplayName(modelData.name)
                    color: theme.mantle
                    font.pixelSize: 11
                    font.bold: true
                    font.family: theme.fontFamily
                }
            }

            // Inactive Workspace Layout
            Text {
                anchors.centerIn: parent
                visible: !modelData.is_focused
                text: getWorkspaceIcon(modelData.name)
                color: modelData.active_window_id ? theme.text : theme.overlay
                font.pixelSize: 12
                font.family: theme.fontFamily
                opacity: modelData.active_window_id ? 0.85 : 0.4
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            MouseArea {
                id: wsMouse
                anchors.fill: parent
                hoverEnabled: true
                property bool hovered: false
                onEntered: hovered = true
                onExited: hovered = false
                
                onClicked: {
                    Quickshell.execDetached({
                        command: ["niri", "msg", "action", "focus-workspace", modelData.name || modelData.idx.toString()]
                    });
                }
            }
        }
    }
}
