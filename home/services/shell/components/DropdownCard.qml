import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Shapes

Item {
    id: root
    
    // Dynamic premium sizing transitions based on active dropdown state
    // We add 16px of top padding to root so that it physically touches the top bar (at y: 32)
    width: activeDropdown === "clock" ? parentWidth * 0.55 : 250
    height: (activeDropdown === "clock" ? 480 : 120) + 16
    
    property var theme
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
        "media_status": "Stopped",
        "media_source": "None",
        "media_position": 0,
        "media_length": 0,
        "cpu_name": "Generic CPU",
        "gpu_name": "Generic GPU",
        "os_name": "Linux",
        "wm_name": "Unknown",
        "host_name": "linux",
        "weather_temp": "--°C",
        "weather_desc": "Unknown"
    }
    property string activeDropdown: ""
    property real dropdownX: 0
    property real parentWidth: 0

    // Tab control state inside Clock Central Dashboard
    property string currentTab: "dashboard" // "dashboard", "media", "performance"
    
    // Align root exactly touching the bottom of mainBar (y: 32) so there is absolutely ZERO input region gap!
    y: activeDropdown !== "" ? 32 : 16
    x: Math.max(10, Math.min(parentWidth - width - 10, dropdownX - width / 2))
    
    opacity: activeDropdown !== "" ? 1.0 : 0.0
    scale: activeDropdown !== "" ? 1.0 : 0.95
    
    Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
    Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
    Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
    Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
    Behavior on opacity { NumberAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

    // Actual visual card body with 16px transparent gap at the top to preserve the beautiful floating look
    Rectangle {
        id: cardBody
        anchors.fill: parent
        anchors.topMargin: 16
        radius: 16
        color: "#f21e1e2e" // 95% opacity Catppuccin Mocha Base for deep premium contrast
        border.color: theme ? theme.surface : "#313244"
        border.width: 1
    }


    // =========================================================================
    // 1. SMALL DROPDOWN LAYOUTS (CPU, Vol, WiFi)
    // =========================================================================
    ColumnLayout {
        anchors.fill: cardBody
        anchors.margins: 12
        spacing: 8
        visible: activeDropdown !== "" && activeDropdown !== "clock"
        
        // CPU & RAM Dropdown Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: activeDropdown === "cpu_ram"

            RowLayout {
                Text { text: "󰍛 System Performance"; color: theme ? theme.red : "#f38ba8"; font.bold: true; font.pixelSize: 12; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                Item { Layout.fillWidth: true }
                Text { text: (sysInfo ? sysInfo.cpu_temp : 0) + "°C"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF" }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: "CPU Load"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Item { Layout.fillWidth: true }
                    Text { text: (sysInfo ? sysInfo.cpu : 0) + "%"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                }
                Rectangle {
                    height: 6
                    Layout.fillWidth: true
                    radius: 3
                    color: theme ? theme.surface : "#313244"
                    Rectangle {
                        height: 6
                        width: parent.width * ((sysInfo ? sysInfo.cpu : 0) / 100.0)
                        radius: 3
                        color: theme ? theme.red : "#f38ba8"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: "Memory (RAM)"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Item { Layout.fillWidth: true }
                    Text { text: sysInfo ? sysInfo.ram_detail : "0G / 0G"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                }
                Rectangle {
                    height: 6
                    Layout.fillWidth: true
                    radius: 3
                    color: theme ? theme.surface : "#313244"
                    Rectangle {
                        height: 6
                        width: parent.width * ((sysInfo ? sysInfo.ram : 0) / 100.0)
                        radius: 3
                        color: theme ? theme.peach : "#fab387"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

        // Volume & Brightness Dropdown Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: activeDropdown === "vol_bright"

            RowLayout {
                Text { text: "󰕾 Audio & Brightness"; color: theme ? theme.yellow : "#f9e2af"; font.bold: true; font.pixelSize: 12; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                Item { Layout.fillWidth: true }
                Text { text: sysInfo ? (sysInfo.muted ? "Muted" : "Active") : "Active"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF" }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: "Volume"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Item { Layout.fillWidth: true }
                    Text { text: (sysInfo ? sysInfo.vol : 0) + "%"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                }
                Rectangle {
                    height: 6
                    Layout.fillWidth: true
                    radius: 3
                    color: theme ? theme.surface : "#313244"
                    Rectangle {
                        height: 6
                        width: parent.width * ((sysInfo ? sysInfo.vol : 0) / 100.0)
                        radius: 3
                        color: sysInfo ? (sysInfo.muted ? (theme ? theme.overlay : "#585b70") : (theme ? theme.yellow : "#f9e2af")) : "#f9e2af"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: "Brightness"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Item { Layout.fillWidth: true }
                    Text { text: (sysInfo ? sysInfo.brightness : 0) + "%"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                }
                Rectangle {
                    height: 6
                    Layout.fillWidth: true
                    radius: 3
                    color: theme ? theme.surface : "#313244"
                    Rectangle {
                        height: 6
                        width: parent.width * ((sysInfo ? sysInfo.brightness : 0) / 100.0)
                        radius: 3
                        color: theme ? theme.lavender : "#b4befe"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

        // WiFi & Battery Dropdown Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: activeDropdown === "wifi_bat"

            RowLayout {
                Text { text: "󰖩 Connection & Power"; color: theme ? theme.blue : "#89b4fa"; font.bold: true; font.pixelSize: 12; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                Item { Layout.fillWidth: true }
                Text { text: sysInfo ? sysInfo.wifi : ""; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF"; elide: Text.ElideRight; Layout.maximumWidth: 100 }
            }
            
            RowLayout {
                spacing: 4
                Text { text: "Local IP:"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                Text { text: sysInfo ? sysInfo.ip_addr : "127.0.0.1"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.bold: true; font.family: theme ? theme.fontFamily : "Iosevka NF" }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: "Battery Status"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Item { Layout.fillWidth: true }
                    Text { text: (sysInfo ? sysInfo.bat_cap : 100) + "% (" + (sysInfo ? (sysInfo.bat_status === "Discharging" ? "Battery" : sysInfo.bat_status) : "Unknown") + ")"; color: theme ? theme.text : "#cdd6f4"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                }
                Rectangle {
                    height: 6
                    Layout.fillWidth: true
                    radius: 3
                    color: theme ? theme.surface : "#313244"
                    Rectangle {
                        height: 6
                        width: parent.width * ((sysInfo ? sysInfo.bat_cap : 100) / 100.0)
                        radius: 3
                        color: theme ? theme.green : "#a6e3a1"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 2. CENTRAL HIGH-END DASHBOARD LAYOUT (Clock Dropdown)
    // =========================================================================
    ColumnLayout {
        anchors.fill: cardBody
        anchors.margins: 14
        spacing: 10
        visible: activeDropdown === "clock"

        // ----------------------------------------------------
        // Tabs Navigation Header
        // ----------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: 24
            Layout.alignment: Qt.AlignHCenter
            
            Repeater {
                model: [
                    { id: "dashboard", icon: "󰕮", name: "Dashboard" },
                    { id: "media", icon: "󰎈", name: "Media" },
                    { id: "performance", icon: "󰍛", name: "Performance" }
                ]
                delegate: MouseArea {
                    width: tabRow.width + 20
                    height: 32
                    hoverEnabled: true
                    property bool hovered: false
                    onEntered: hovered = true
                    onExited: hovered = false
                    onClicked: currentTab = modelData.id
                    
                    RowLayout {
                        id: tabRow
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text {
                            text: modelData.icon
                            color: currentTab === modelData.id ? (theme ? theme.mauve : "#cba6f7") : "#a6adc8"
                            font.pixelSize: 14
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                        }
                        Text {
                            text: modelData.name
                            color: currentTab === modelData.id ? (theme ? theme.text : "#cdd6f4") : "#a6adc8"
                            font.pixelSize: 12
                            font.bold: currentTab === modelData.id
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                        }
                    }

                    // Active underline
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 2
                        width: parent.width * (currentTab === modelData.id ? 0.8 : 0.0)
                        color: theme ? theme.mauve : "#cba6f7"
                        Behavior on width { NumberAnimation { duration: 150 } }
                    }
                }
            }
        }

        // Horizontal Separator
        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: theme ? theme.surface : "#313244"
            opacity: 0.3
        }

        // Tab Content Container to prevent multiple active Layout.fillHeight elements
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            DashboardTab {
                anchors.fill: parent
                visible: currentTab === "dashboard"
                theme: root.theme
                sysInfo: root.sysInfo
            }

            MediaTab {
                anchors.fill: parent
                visible: currentTab === "media"
                theme: root.theme
                sysInfo: root.sysInfo
            }

            PerformanceTab {
                anchors.fill: parent
                visible: currentTab === "performance"
                theme: root.theme
                sysInfo: root.sysInfo
            }
        }
    }
}
