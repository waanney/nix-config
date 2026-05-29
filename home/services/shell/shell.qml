import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "./components"

ShellRoot {
    id: root
    // Instantiate modular Theme properties
    Theme { id: theme }

    // ----------------------------------------------------
    // State properties
    // ----------------------------------------------------
    property var workspacesList: []
    property string activeWindowTitle: ""
    property string activeWindowAppId: ""
    property var sysInfo: {
        "wifi": "Disconnected",
        "ip_addr": "127.0.0.1",
        "bat_cap": 100,
        "bat_status": "Unknown",
        "vol": 0,
        "muted": false,
        "brightness": 100,
        "ram": 0,
        "ram_detail": "0G / 0G",
        "cpu": 0,
        "cpu_temp": 0,
        "uptime": "0h 0m",
        "media_title": "Nothing playing",
        "media_artist": "Idle",
        "media_status": "Stopped"
    }

    property string activeDropdown: "" // "", "cpu_ram", "vol_bright", "wifi_bat", "clock"
    property real dropdownX: 0

    // ----------------------------------------------------
    // Helper helper functions
    // ----------------------------------------------------
    function getAppIcon(appId, title) {
        if (!appId) return "󰣇";
        var lowerApp = appId.toLowerCase();
        var lowerTitle = title ? title.toLowerCase() : "";
        if (lowerApp.indexOf("firefox") !== -1 || lowerApp.indexOf("zen") !== -1) return "󰈹";
        if (lowerApp.indexOf("code") !== -1 || lowerApp.indexOf("visualstudio") !== -1) return "󰨞";
        if (lowerApp.indexOf("wezterm") !== -1 || lowerApp.indexOf("kitty") !== -1 || lowerApp.indexOf("foot") !== -1 || lowerApp.indexOf("alacritty") !== -1) return "󰞷";
        if (lowerApp.indexOf("spotify") !== -1) return "󰓇";
        if (lowerApp.indexOf("discord") !== -1) return "󰙯";
        if (lowerApp.indexOf("telegram") !== -1) return "󰭹";
        if (lowerApp.indexOf("slack") !== -1) return "󰒱";
        if (lowerApp.indexOf("thunar") !== -1 || lowerApp.indexOf("nautilus") !== -1 || lowerApp.indexOf("dolphin") !== -1) return "󰉋";
        if (lowerApp.indexOf("neovim") !== -1 || lowerApp.indexOf("nvim") !== -1) return "";
        return "󰣇";
    }

    function getAppIconColor(appId) {
        if (!appId) return theme.subtext;
        var lower = appId.toLowerCase();
        if (lower.indexOf("firefox") !== -1) return theme.peach;
        if (lower.indexOf("zen") !== -1) return theme.blue;
        if (lower.indexOf("code") !== -1) return theme.blue;
        if (lower.indexOf("wezterm") !== -1 || lower.indexOf("kitty") !== -1 || lower.indexOf("foot") !== -1 || lower.indexOf("alacritty") !== -1) return theme.green;
        if (lower.indexOf("spotify") !== -1) return theme.green;
        if (lower.indexOf("discord") !== -1) return theme.blue;
        if (lower.indexOf("telegram") !== -1) return theme.blue;
        if (lower.indexOf("slack") !== -1) return theme.mauve;
        if (lower.indexOf("neovim") !== -1 || lower.indexOf("nvim") !== -1) return theme.green;
        return theme.subtext;
    }

    // ----------------------------------------------------
    // Processes for fetching data
    // ----------------------------------------------------
    
    // System Info Process (polls sysinfo.sh helper script)
    Process {
        id: sysInfoProcess
        command: [Qt.resolvedUrl("sysinfo.sh").toString().replace("file://", "")]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parsed = JSON.parse(this.text.trim());
                    sysInfo = parsed;
                } catch (e) {
                    console.log("Error parsing system info JSON:", e);
                }
            }
        }
    }

    // Workspaces Process (fetch active workspace info from Niri)
    Process {
        id: workspacesProcess
        command: ["niri", "msg", "-j", "workspaces"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parsed = JSON.parse(this.text.trim());
                    parsed.sort((a, b) => a.idx - b.idx);
                    workspacesList = parsed;
                } catch (e) {
                    console.log("Error parsing workspaces:", e);
                }
            }
        }
    }

    // Windows Process (fetch active/focused window title from Niri)
    Process {
        id: windowsProcess
        command: ["niri", "msg", "-j", "windows"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parsed = JSON.parse(this.text.trim());
                    var found = false;
                    for (var i = 0; i < parsed.length; i++) {
                        if (parsed[i].is_focused) {
                            activeWindowTitle = parsed[i].title || "";
                            activeWindowAppId = parsed[i].app_id || "";
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        activeWindowTitle = "";
                        activeWindowAppId = "";
                    }
                } catch (e) {
                    console.log("Error parsing windows:", e);
                }
            }
        }
    }

    // ----------------------------------------------------
    // Polling Timers
    // ----------------------------------------------------
    
    // Ultra-fast timer (100ms) for real-time instantaneous updates
    Timer {
        id: niriTimer
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!workspacesProcess.running) workspacesProcess.running = true;
            if (!windowsProcess.running) windowsProcess.running = true;
        }
    }

    // Faster timer (2s) for System stats
    Timer {
        id: sysInfoTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!sysInfoProcess.running) sysInfoProcess.running = true;
        }
    }

    // ----------------------------------------------------
    // Main Topbar Window Layout
    // ----------------------------------------------------
    PanelWindow {
        id: panel
        color: "transparent"
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 440
        exclusiveZone: 46

        // Define Dynamic Input Regions to force instant Wayland clickthrough updates
        Region {
            id: barOnlyRegion
            Region { item: mainBar }
        }
        
        Region {
            id: fullRegion
            Region { item: mainBar }
            Region {
                item: dropdownCard
                intersection: Intersection.Combine
            }
        }

        mask: root.activeDropdown !== "" ? fullRegion : barOnlyRegion

        // Floating rounded glassmorphism bar
        Rectangle {
            id: mainBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 36
            anchors.topMargin: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            radius: 12
            color: "#e611111b" // 90% opacity Catppuccin Mocha Mantle
            border.color: theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                // ==========================================
                // LEFT: Workspaces & Window Title
                // ==========================================
                RowLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignVCenter

                    // Modular Workspaces List component
                    WorkspaceList {
                        workspaces: root.workspacesList
                        theme: theme
                    }

                    // Separator line
                    Rectangle {
                        width: 1
                        height: 14
                        color: theme.surface
                        Layout.alignment: Qt.AlignVCenter
                        visible: activeWindowTitle !== ""
                    }

                    // Active Window Title capsule
                    Rectangle {
                        height: 26
                        implicitWidth: activeWindowRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: theme.surface
                        border.width: 1
                        visible: activeWindowTitle !== ""
                        Layout.alignment: Qt.AlignVCenter
                        Layout.maximumWidth: 250

                        RowLayout {
                            id: activeWindowRow
                            anchors.centerIn: parent
                            spacing: 6
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8

                            Text {
                                text: getAppIcon(activeWindowAppId, activeWindowTitle)
                                color: getAppIconColor(activeWindowAppId)
                                font.pixelSize: 13
                                font.family: theme.fontFamily
                            }

                            Text {
                                text: activeWindowTitle
                                color: theme.subtext
                                font.pixelSize: 11
                                font.family: theme.fontFamily
                                elide: Text.ElideRight
                                Layout.maximumWidth: 180
                            }
                        }
                    }
                }

                // Spacer pushing Clock to the center
                Item { Layout.fillWidth: true }

                // ==========================================
                // CENTER: Clock & Date Widget
                // ==========================================
                ClockWidget {
                    id: clockPill
                    theme: theme
                    sysInfo: root.sysInfo
                    onPillClicked: (xCoord, type) => {
                        if (activeDropdown === type) {
                            activeDropdown = "";
                        } else {
                            dropdownX = xCoord;
                            activeDropdown = type;
                        }
                    }
                }

                // Spacer pushing Stats to the right
                Item { Layout.fillWidth: true }

                // ==========================================
                // RIGHT: System Stats & System Tray
                // ==========================================
                RowLayout {
                    spacing: 10
                    Layout.alignment: Qt.AlignVCenter

                    // CPU & RAM usage pill (triggers dropdown)
                    Rectangle {
                        id: cpuRamPill
                        height: 26
                        implicitWidth: cpuRamRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: cpuRamMouse.hovered ? theme.overlay : theme.surface
                        border.width: 1
                        
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            id: cpuRamRow
                            anchors.centerIn: parent
                            spacing: 8

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰍛"
                                    color: theme.red
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.cpu + "%"
                                    color: theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                }
                            }

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰘚"
                                    color: theme.peach
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.ram + "%"
                                    color: theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                }
                            }
                        }

                        MouseArea {
                            id: cpuRamMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                if (activeDropdown === "cpu_ram") {
                                    activeDropdown = "";
                                } else {
                                    var pos = parent.mapToItem(null, 0, 0);
                                    dropdownX = pos.x + parent.width / 2;
                                    activeDropdown = "cpu_ram";
                                }
                            }
                        }
                    }

                    // Volume & Brightness pill (triggers dropdown)
                    Rectangle {
                        id: volBrightPill
                        height: 26
                        implicitWidth: volBrightRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: volBrightMouse.hovered ? theme.overlay : theme.surface
                        border.width: 1
                        
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            id: volBrightRow
                            anchors.centerIn: parent
                            spacing: 8

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: sysInfo.muted ? "󰝟" : (sysInfo.vol > 66 ? "󰕾" : (sysInfo.vol > 33 ? "󰖀" : "󰕿"))
                                    color: sysInfo.muted ? theme.overlay : theme.yellow
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.vol + "%"
                                    color: sysInfo.muted ? theme.overlay : theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                }
                            }

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰃠"
                                    color: theme.lavender
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.brightness + "%"
                                    color: theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                }
                            }
                        }

                        MouseArea {
                            id: volBrightMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                if (activeDropdown === "vol_bright") {
                                    activeDropdown = "";
                                } else {
                                    var pos = parent.mapToItem(null, 0, 0);
                                    dropdownX = pos.x + parent.width / 2;
                                    activeDropdown = "vol_bright";
                                }
                            }
                        }
                    }

                    // WiFi & Battery pill (triggers dropdown)
                    Rectangle {
                        id: wifiBatPill
                        height: 26
                        implicitWidth: wifiBatRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: wifiBatMouse.hovered ? theme.overlay : theme.surface
                        border.width: 1
                        
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            id: wifiBatRow
                            anchors.centerIn: parent
                            spacing: 8

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰖩"
                                    color: theme.blue
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.wifi
                                    color: theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 80
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            RowLayout {
                                spacing: 4
                                Text {
                                    text: sysInfo.bat_status === "Charging" ? "󰂄" : (sysInfo.bat_cap > 80 ? "󰁹" : (sysInfo.bat_cap > 50 ? "󰁾" : (sysInfo.bat_cap > 20 ? "󰁼" : "󰁺")))
                                    color: theme.green
                                    font.pixelSize: 13
                                    font.family: theme.fontFamily
                                }
                                Text {
                                    text: sysInfo.bat_cap + "%"
                                    color: theme.text
                                    font.pixelSize: 11
                                    font.family: theme.fontFamily
                                }
                            }
                        }

                        MouseArea {
                            id: wifiBatMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                if (activeDropdown === "wifi_bat") {
                                    activeDropdown = "";
                                } else {
                                    var pos = parent.mapToItem(null, 0, 0);
                                    dropdownX = pos.x + parent.width / 2;
                                    activeDropdown = "wifi_bat";
                                }
                            }
                        }
                    }

                    // System Tray Section
                    Row {
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 6
                        
                        Repeater {
                            model: SystemTray.items
                            delegate: MouseArea {
                                id: trayItemMouse
                                width: 24
                                height: 24
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                hoverEnabled: true
                                property bool hovered: false
                                onEntered: hovered = true
                                onExited: hovered = false

                                QsMenuAnchor {
                                    id: menuAnchor
                                    menu: modelData.menu
                                }

                                IconImage {
                                    anchors.fill: parent
                                    source: modelData.icon
                                    implicitSize: 18
                                    opacity: trayItemMouse.hovered ? 1.0 : 0.8
                                    scale: trayItemMouse.hovered ? 1.1 : 1.0
                                    
                                    Behavior on opacity { NumberAnimation { duration: 100 } }
                                    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }
                                }

                                onClicked: (mouse) => {
                                    if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                        menuAnchor.display()
                                    } else {
                                        modelData.activate()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // ==========================================
        // BACKDROP MOUSEAREA (Click away to close)
        // ==========================================
        MouseArea {
            anchors.fill: parent
            visible: root.activeDropdown !== ""
            onClicked: {
                root.activeDropdown = "";
            }
        }

        // ==========================================
        // FLOATING DROPDOWN CARD (Slides down beautifully)
        // ==========================================
        DropdownCard {
            id: dropdownCard
            theme: theme
            sysInfo: root.sysInfo
            activeDropdown: root.activeDropdown
            dropdownX: root.dropdownX
            parentWidth: panel.width
        }
    }
}
