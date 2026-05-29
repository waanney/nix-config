import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: dockRoot

    property var theme
    property var runningApps: []
    property bool revealed: false
    property real dockWidth: dockBg.width

    height: 76

    opacity: revealed ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 150 } }

    function appIcon(appId) {
        if (!appId) return "";
        var lower = appId.toLowerCase();
        if (lower.indexOf("firefox") !== -1 || lower.indexOf("zen") !== -1) return "󰈹";
        if (lower.indexOf("code") !== -1 || lower.indexOf("visualstudio") !== -1) return "󰨞";
        if (lower.indexOf("wezterm") !== -1 || lower.indexOf("kitty") !== -1 || lower.indexOf("foot") !== -1 || lower.indexOf("alacritty") !== -1) return "󰞷";
        if (lower.indexOf("spotify") !== -1) return "󰓇";
        if (lower.indexOf("discord") !== -1 || lower.indexOf("vesktop") !== -1) return "󰙯";
        if (lower.indexOf("telegram") !== -1) return "󰭹";
        if (lower.indexOf("slack") !== -1) return "󰒱";
        if (lower.indexOf("thunar") !== -1 || lower.indexOf("nautilus") !== -1 || lower.indexOf("dolphin") !== -1) return "󰉋";
        if (lower.indexOf("neovim") !== -1 || lower.indexOf("nvim") !== -1) return "";
        return "";
    }

    function appColor(appId) {
        if (!appId) return theme ? theme.subtext : "#a6adc8";
        var lower = appId.toLowerCase();
        if (lower.indexOf("firefox") !== -1) return theme ? theme.peach : "#fab387";
        if (lower.indexOf("zen") !== -1) return theme ? theme.blue : "#89b4fa";
        if (lower.indexOf("code") !== -1) return theme ? theme.blue : "#89b4fa";
        if (lower.indexOf("wezterm") !== -1 || lower.indexOf("kitty") !== -1 || lower.indexOf("foot") !== -1 || lower.indexOf("alacritty") !== -1) return theme ? theme.green : "#a6e3a1";
        if (lower.indexOf("spotify") !== -1) return theme ? theme.green : "#a6e3a1";
        if (lower.indexOf("discord") !== -1 || lower.indexOf("vesktop") !== -1) return theme ? theme.blue : "#89b4fa";
        if (lower.indexOf("telegram") !== -1) return theme ? theme.blue : "#89b4fa";
        if (lower.indexOf("slack") !== -1) return theme ? theme.mauve : "#cba6f7";
        if (lower.indexOf("neovim") !== -1 || lower.indexOf("nvim") !== -1) return theme ? theme.green : "#a6e3a1";
        return theme ? theme.subtext : "#a6adc8";
    }

    property var pinnedApps: [
        { appId: "firefoxdeveloperedition", command: "firefoxdeveloperedition" },
        { appId: "zen", command: "zen" },
        { appId: "code", command: "code" },
        { appId: "wezterm", command: "wezterm" },
        { appId: "spotify", command: "spotify" },
        { appId: "nautilus", command: "nautilus" },
        { appId: "vesktop", command: "vesktop" },
    ]

    property var extraRunning: {
        var result = [];
        for (var i = 0; i < runningApps.length; i++) {
            var found = false;
            var runningLower = runningApps[i].toLowerCase();
            for (var j = 0; j < pinnedApps.length; j++) {
                var pinnedLower = pinnedApps[j].appId.toLowerCase();
                if (runningLower.indexOf(pinnedLower) !== -1 || pinnedLower.indexOf(runningLower) !== -1) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                result.push({ appId: runningApps[i] });
            }
        }
        return result;
    }

    function isRunning(appId) {
        var lower = appId.toLowerCase();
        for (var i = 0; i < runningApps.length; i++) {
            var runningLower = runningApps[i].toLowerCase();
            if (runningLower.indexOf(lower) !== -1 || lower.indexOf(runningLower) !== -1) return true;
        }
        return false;
    }

    function focusApp(appId) {
        var lower = appId.toLowerCase();
        for (var i = 0; i < runningApps.length; i++) {
            if (runningApps[i].toLowerCase().indexOf(lower) !== -1 || lower.indexOf(runningApps[i].toLowerCase()) !== -1) {
                Quickshell.execDetached({ command: ["niri", "msg", "action", "focus-window", '[{"app-id":"' + runningApps[i] + '"}]'] });
                return;
            }
        }
        launchApp(appId);
    }

    function launchApp(command) {
        if (command) {
            Quickshell.execDetached({ command: ["/bin/sh", "-c", command] });
        }
    }

    // Click/double-click state
    property var _clickedItem: null
    property bool _pending: false
    Timer {
        id: _clickTimer
        interval: 250
        onTriggered: {
            if (_pending && _clickedItem) {
                var id = _clickedItem._dockAppId;
                var cmd = _clickedItem._dockCommand;
                if (isRunning(id)) {
                    focusApp(id);
                } else {
                    launchApp(cmd || id);
                }
            }
            _pending = false;
            _clickedItem = null;
        }
    }

    function handleDoubleClick(appId, command) {
        launchApp(command || appId);
    }

    // Hover state
    property Item _hoveredItem: null

    function _findItem(child) {
        if (!child) return null;
        if (child._isDockItem) return child;
        return _findItem(child.parent);
    }

    function clearHover() {
        if (_hoveredItem) {
            _hoveredItem.iconScale = 1.0;
            _hoveredItem.hovered = false;
            _hoveredItem = null;
        }
    }

    function setHover(child) {
        clearHover();
        if (child && child._isDockItem) {
            _hoveredItem = child;
            child.iconScale = 1.25;
            child.hovered = true;
        }
    }

    Rectangle {
        id: dockBg
        anchors.centerIn: parent
        width: dockContent.width + 24
        height: 64
        radius: 18
        color: "#e611111b"
        border.color: theme ? theme.surface : "#313244"
        border.width: 1

        Rectangle {
            anchors.fill: parent
            radius: 18
            color: theme ? theme.mauve : "#cba6f7"
            opacity: 0.04
        }
    }

    RowLayout {
        id: dockContent
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: pinnedApps
            delegate: Item {
                width: 52
                height: 52
                property real iconScale: 1.0
                property bool hovered: false
                readonly property string _dockAppId: modelData ? modelData.appId : ""
                readonly property string _dockCommand: modelData ? (modelData.command || modelData.appId) : ""
                readonly property bool _isDockItem: true

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 12
                    color: theme ? theme.surface : "#313244"
                    opacity: parent.hovered ? 0.6 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 12
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: appIcon(modelData.appId)
                        color: appColor(modelData.appId)
                        font.pixelSize: 22
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                    }
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    width: 5
                    height: 5
                    radius: 2.5
                    color: isRunning(modelData.appId) ? (theme ? theme.mauve : "#cba6f7") : "transparent"
                    Behavior on color { ColorAnimation { duration: 300 } }
                }

                transform: Scale { origin.x: 26; origin.y: 26; xScale: iconScale; yScale: iconScale }
                Behavior on iconScale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
            }
        }

        Rectangle {
            width: 1
            height: 36
            color: theme ? theme.surface : "#313244"
            Layout.alignment: Qt.AlignVCenter
            visible: extraRunning.length > 0
            Layout.leftMargin: 6
            Layout.rightMargin: 6
        }

        Repeater {
            model: extraRunning
            delegate: Item {
                width: 52
                height: 52
                property real iconScale: 1.0
                property bool hovered: false
                readonly property string _dockAppId: modelData ? (modelData.appId || "") : ""
                readonly property string _dockCommand: modelData ? (modelData.appId || "") : ""
                readonly property bool _isDockItem: true

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 12
                    color: theme ? theme.surface : "#313244"
                    opacity: parent.hovered ? 0.6 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 12
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: appIcon(modelData.appId)
                        color: appColor(modelData.appId)
                        font.pixelSize: 22
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                    }
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    width: 5
                    height: 5
                    radius: 2.5
                    color: theme ? theme.mauve : "#cba6f7"
                }

                transform: Scale { origin.x: 26; origin.y: 26; xScale: iconScale; yScale: iconScale }
                Behavior on iconScale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
            }
        }

        Item { width: 8 }

        Item {
            width: 52
            height: 52
            property real iconScale: 1.0
            property bool hovered: false
            readonly property string _dockAppId: "nautilus"
            readonly property string _dockCommand: "nautilus"

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: 12
                color: theme ? theme.surface : "#313244"
                opacity: parent.hovered ? 0.6 : 0.0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: 12
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "󰉋"
                    color: theme ? theme.blue : "#89b4fa"
                    font.pixelSize: 22
                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                }
            }

            transform: Scale { origin.x: 26; origin.y: 26; xScale: iconScale; yScale: iconScale }
            Behavior on iconScale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
        }

        Item {
            width: 52
            height: 52
            property real iconScale: 1.0
            property bool hovered: false
            readonly property string _dockAppId: "nautilus"
            readonly property string _dockCommand: "nautilus trash://"
            readonly property bool _isDockItem: true

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: 12
                color: theme ? theme.surface : "#313244"
                opacity: parent.hovered ? 0.6 : 0.0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: 12
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "󰁽"
                    color: theme ? theme.subtext : "#a6adc8"
                    font.pixelSize: 22
                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                }
            }

            transform: Scale { origin.x: 26; origin.y: 26; xScale: iconScale; yScale: iconScale }
            Behavior on iconScale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
        }
    }

    // Single central MouseArea for all interactions
    MouseArea {
        anchors.fill: dockRoot
        hoverEnabled: true

        onPositionChanged: function(mouse) {
            var pos = mapToItem(dockContent, mouse.x, mouse.y);
            var child = dockContent.childAt(pos.x, pos.y);
            var item = _findItem(child);
            if (item !== _hoveredItem) {
                clearHover();
                if (item) setHover(item);
            }
        }

        onExited: {
            clearHover();
        }

        onClicked: function(mouse) {
            var pos = mapToItem(dockContent, mouse.x, mouse.y);
            var child = dockContent.childAt(pos.x, pos.y);
            var item = _findItem(child);
            if (!item) return;

            if (_pending && _clickedItem === item) {
                _clickTimer.stop();
                _pending = false;
                _clickedItem = null;
                handleDoubleClick(item._dockAppId, item._dockCommand);
            } else {
                _pending = true;
                _clickedItem = item;
                _clickTimer.restart();
            }
        }
    }
}
