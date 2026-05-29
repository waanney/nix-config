import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ShellRoot {
    // ----------------------------------------------------
    // State properties
    // ----------------------------------------------------
    property var workspacesList: []
    property string activeWindowTitle: ""
    property string activeWindowAppId: ""
    property var sysInfo: {
        "wifi": "Disconnected",
        "bat_cap": 100,
        "bat_status": "Unknown",
        "vol": 0,
        "muted": false,
        "brightness": 100,
        "ram": 0,
        "cpu": 0
    }

    // ----------------------------------------------------
    // Helper helper functions
    // ----------------------------------------------------
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
    
    // Fast timer (1s) for Niri workspaces and windows
    Timer {
        id: niriTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!workspacesProcess.running) workspacesProcess.running = true;
            if (!windowsProcess.running) windowsProcess.running = true;
        }
    }

    // Slow timer (3s) for System stats
    Timer {
        id: sysInfoTimer
        interval: 3000
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
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 44
        exclusiveZone: implicitHeight

        // Floating rounded glassmorphism bar
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 4
            anchors.bottomMargin: 4
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            radius: 12
            color: "#e611111b" // 90% opacity Catppuccin Mocha Mantle
            border.color: "#313244"
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
                    spacing: 10
                    Layout.alignment: Qt.AlignVCenter

                    // Workspaces List
                    Row {
                        spacing: 6
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: workspacesList
                            delegate: Rectangle {
                                width: modelData.is_focused ? 80 : 28
                                height: 26
                                radius: 13
                                Behavior on width { NumberAnimation { duration: 150 } }
                                
                                color: modelData.is_focused ? "#cba6f7" : (modelData.active_window_id ? "#313244" : "transparent")
                                border.color: modelData.is_focused ? "transparent" : (modelData.active_window_id ? "#45475a" : "#313244")
                                border.width: 1

                                // Label for focused workspace (Icon + Name)
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    visible: modelData.is_focused

                                    Text {
                                        text: getWorkspaceIcon(modelData.name)
                                        color: "#11111b"
                                        font.pixelSize: 13
                                        font.family: "Iosevka NF"
                                    }
                                    Text {
                                        text: getWorkspaceDisplayName(modelData.name)
                                        color: "#11111b"
                                        font.pixelSize: 11
                                        font.bold: true
                                        font.family: "Iosevka NF"
                                    }
                                }

                                // Icon for inactive workspace
                                Text {
                                    anchors.centerIn: parent
                                    visible: !modelData.is_focused
                                    text: getWorkspaceIcon(modelData.name)
                                    color: modelData.active_window_id ? "#cdd6f4" : "#585b70"
                                    font.pixelSize: 12
                                    font.family: "Iosevka NF"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        Quickshell.execDetached({
                                            command: ["niri", "msg", "action", "focus-workspace", modelData.name || modelData.idx.toString()]
                                        });
                                    }
                                }
                            }
                        }
                    }

                    // Separator line
                    Rectangle {
                        width: 1
                        height: 14
                        color: "#45475a"
                        Layout.alignment: Qt.AlignVCenter
                        visible: activeWindowTitle !== ""
                    }

                    // Active Window Title
                    Text {
                        text: activeWindowTitle
                        color: "#a6adc8"
                        font.pixelSize: 12
                        font.family: "Iosevka NF"
                        elide: Text.ElideRight
                        Layout.maximumWidth: 200
                        visible: activeWindowTitle !== ""
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                // Spacer pushing Clock to the center
                Item { Layout.fillWidth: true }

                // ==========================================
                // CENTER: Clock & Date
                // ==========================================
                RowLayout {
                    spacing: 6
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Text {
                        id: clockLabel
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "Iosevka NF"
                        text: Qt.formatDateTime(new Date(), "HH:mm")
                        
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: {
                                clockLabel.text = Qt.formatDateTime(new Date(), "HH:mm");
                                dateLabel.text = Qt.formatDateTime(new Date(), "ddd, MMM d");
                            }
                        }
                    }

                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: "#45475a"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        id: dateLabel
                        color: "#a6adc8"
                        font.pixelSize: 12
                        font.family: "Iosevka NF"
                        text: Qt.formatDateTime(new Date(), "ddd, MMM d")
                    }
                }

                // Spacer pushing Stats to the right
                Item { Layout.fillWidth: true }

                // ==========================================
                // RIGHT: System Stats & System Tray
                // ==========================================
                RowLayout {
                    spacing: 8
                    Layout.alignment: Qt.AlignVCenter

                    // CPU & RAM usage pill
                    Rectangle {
                        height: 26
                        implicitWidth: cpuRamRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: "#313244"
                        border.width: 1

                        RowLayout {
                            id: cpuRamRow
                            anchors.centerIn: parent
                            spacing: 8

                            // CPU
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰍛"
                                    color: "#f38ba8" // Red
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.cpu + "%"
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
                                }
                            }

                            // RAM
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰘚"
                                    color: "#fab387" // Peach
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.ram + "%"
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
                                }
                            }
                        }
                    }

                    // Volume & Brightness pill
                    Rectangle {
                        height: 26
                        implicitWidth: volBrightRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: "#313244"
                        border.width: 1

                        RowLayout {
                            id: volBrightRow
                            anchors.centerIn: parent
                            spacing: 8

                            // Volume
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: sysInfo.muted ? "󰝟" : (sysInfo.vol > 66 ? "󰕾" : (sysInfo.vol > 33 ? "󰖀" : "󰕿"))
                                    color: sysInfo.muted ? "#585b70" : "#f9e2af" // Yellow
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.vol + "%"
                                    color: sysInfo.muted ? "#585b70" : "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
                                }
                            }

                            // Brightness
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰃠"
                                    color: "#b4befe" // Lavender
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.brightness + "%"
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
                                }
                            }
                        }
                    }

                    // WiFi & Battery pill
                    Rectangle {
                        height: 26
                        implicitWidth: wifiBatRow.width + 16
                        radius: 13
                        color: "#181825"
                        border.color: "#313244"
                        border.width: 1

                        RowLayout {
                            id: wifiBatRow
                            anchors.centerIn: parent
                            spacing: 8

                            // WiFi
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: "󰖩"
                                    color: "#89b4fa" // Blue
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.wifi
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 80
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            // Battery
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: sysInfo.bat_status === "Charging" ? "󰂄" : (sysInfo.bat_cap > 80 ? "󰁹" : (sysInfo.bat_cap > 50 ? "󰁾" : (sysInfo.bat_cap > 20 ? "󰁼" : "󰁺")))
                                    color: "#a6e3a1" // Green
                                    font.pixelSize: 13
                                    font.family: "Iosevka NF"
                                }
                                Text {
                                    text: sysInfo.bat_cap + "%"
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                    font.family: "Iosevka NF"
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
                                width: 24
                                height: 24
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                QsMenuAnchor {
                                    id: menuAnchor
                                    menu: modelData.menu
                                }

                                IconImage {
                                    anchors.fill: parent
                                    source: modelData.icon
                                    implicitSize: 18
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
    }
}
