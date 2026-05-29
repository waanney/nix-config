import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    
    // Dynamic premium sizing transitions based on active dropdown state
    // We add 16px of top padding to root so that it physically touches the top bar (at y: 32)
    width: activeDropdown === "clock" ? 660 : 250
    height: (activeDropdown === "clock" ? 380 : 120) + 16
    
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
        "media_status": "Stopped"
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

    // Dynamic month calendar generator
    function getCalendarDays() {
        var days = [];
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth();
        
        var firstDayIndex = new Date(year, month, 1).getDay();
        var startDay = firstDayIndex === 0 ? 6 : firstDayIndex - 1;
        
        var prevMonthDays = new Date(year, month, 0).getDate();
        var currentMonthDays = new Date(year, month + 1, 0).getDate();
        
        for (var i = startDay - 1; i >= 0; i--) {
            days.push({ day: prevMonthDays - i, current: false, today: false });
        }
        
        var today = date.getDate();
        for (var d = 1; d <= currentMonthDays; d++) {
            days.push({ day: d, current: true, today: d === today });
        }
        
        var remaining = 42 - days.length;
        for (var n = 1; n <= remaining; n++) {
            days.push({ day: n, current: false, today: false });
        }
        
        return days;
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
        anchors.margins: 18
        spacing: 14
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

        // ----------------------------------------------------
        // Dashboard Tab Content
        // ----------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            visible: currentTab === "dashboard"

            // LEFT COLUMN: Vertical Large Clock Card (optimized to width: 80px)
            Rectangle {
                Layout.preferredWidth: 80
                Layout.fillHeight: true
                radius: 12
                color: "#181825"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: Qt.formatDateTime(new Date(), "HH")
                        color: theme ? theme.text : "#cdd6f4"
                        font.pixelSize: 26
                        font.bold: true
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "•••"
                        color: theme ? theme.mauve : "#cba6f7"
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: Qt.formatDateTime(new Date(), "mm")
                        color: theme ? theme.text : "#cdd6f4"
                        font.pixelSize: 26
                        font.bold: true
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Item { height: 4 }

                    Text {
                        text: Qt.formatDateTime(new Date(), "ddd, d")
                        color: theme ? theme.subtext : "#a6adc8"
                        font.pixelSize: 10
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // MIDDLE COLUMN: Top (Weather & Profile) + Bottom (Calendar) (takes up rest of 298px!)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Top row (Weather & Profile Cards)
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 75
                    spacing: 10

                    // Weather card (simulated beautiful layout)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#181825"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "󰖙"
                                color: theme ? theme.yellow : "#f9e2af"
                                font.pixelSize: 28
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                            ColumnLayout {
                                spacing: 2
                                Text { text: "25°C"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 13; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                Text { text: "Sunny"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                            }
                        }
                    }

                    // Profile / OS Details card
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#181825"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            // Avatar Circle
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: theme ? theme.surface : "#313244"
                                border.color: theme ? theme.mauve : "#cba6f7"
                                border.width: 1
                                Layout.alignment: Qt.AlignVCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰣇"
                                    color: theme ? theme.blue : "#89b4fa"
                                    font.pixelSize: 18
                                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                                }
                            }

                            ColumnLayout {
                                spacing: 1
                                Layout.alignment: Qt.AlignVCenter

                                RowLayout {
                                    spacing: 4
                                    Text { text: "󱘗"; color: theme ? theme.red : "#f38ba8"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: "NixOS Linux"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                }
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰕮"; color: theme ? theme.blue : "#89b4fa"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: "Niri WM"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                }
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󱎫"; color: theme ? theme.green : "#a6e3a1"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: sysInfo ? sysInfo.uptime : "0h 0m"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                }
                            }
                        }
                    }
                }

                // Bottom row (Calendar Card - Redesigned with absolute responsive GridLayout)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        // Week headers row
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Repeater {
                                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                                delegate: Text {
                                    text: modelData
                                    color: (modelData === "Sa" || modelData === "Su") ? (theme ? theme.red : "#f38ba8") : (theme ? theme.subtext : "#a6adc8")
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        // Fully flexible and responsive GridLayout with explicit implicit delegate sizes to prevent collapsing!
                        GridLayout {
                            columns: 7
                            rowSpacing: 4
                            columnSpacing: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            Repeater {
                                model: getCalendarDays()
                                delegate: Rectangle {
                                    implicitWidth: 24
                                    implicitHeight: 20
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: modelData.today ? (theme ? theme.mauve : "#cba6f7") : "transparent"
                                    radius: 6

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.day.toString()
                                        color: modelData.today 
                                            ? (theme ? theme.mantle : "#11111b") 
                                            : (modelData.current 
                                                ? (theme ? theme.text : "#cdd6f4") 
                                                : (theme ? theme.surface : "#313244"))
                                        font.pixelSize: 9
                                        font.bold: modelData.today
                                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // RIGHT COLUMN: Vertical System Telemetry Sliders (optimized to width: 80px)
            Rectangle {
                Layout.preferredWidth: 80
                Layout.fillHeight: true
                radius: 12
                color: "#181825"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    // CPU Vertical Bar
                    ColumnLayout {
                        Layout.fillHeight: true
                        spacing: 8
                        
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: 8
                            color: theme ? theme.surface : "#313244"
                            radius: 4
                            Layout.alignment: Qt.AlignHCenter
                            
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: parent.height * ((sysInfo ? sysInfo.cpu : 0) / 100.0)
                                color: theme ? theme.red : "#f38ba8"
                                radius: 4
                                Behavior on height { NumberAnimation { duration: 250 } }
                            }
                        }
                        Text { text: "󰍛"; color: theme ? theme.red : "#f38ba8"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF"; Layout.alignment: Qt.AlignHCenter }
                    }

                    // RAM Vertical Bar
                    ColumnLayout {
                        Layout.fillHeight: true
                        spacing: 8
                        
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: 8
                            color: theme ? theme.surface : "#313244"
                            radius: 4
                            Layout.alignment: Qt.AlignHCenter
                            
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: parent.height * ((sysInfo ? sysInfo.ram : 0) / 100.0)
                                color: theme ? theme.peach : "#fab387"
                                radius: 4
                                Behavior on height { NumberAnimation { duration: 250 } }
                            }
                        }
                        Text { text: "󰘚"; color: theme ? theme.peach : "#fab387"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF"; Layout.alignment: Qt.AlignHCenter }
                    }

                    // Battery Vertical Bar
                    ColumnLayout {
                        Layout.fillHeight: true
                        spacing: 8
                        
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: 8
                            color: theme ? theme.surface : "#313244"
                            radius: 4
                            Layout.alignment: Qt.AlignHCenter
                            
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: parent.height * ((sysInfo ? sysInfo.bat_cap : 100) / 100.0)
                                color: theme ? theme.green : "#a6e3a1"
                                radius: 4
                                Behavior on height { NumberAnimation { duration: 250 } }
                            }
                        }
                        Text { text: "󰁹"; color: theme ? theme.green : "#a6e3a1"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF"; Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }

            // FAR RIGHT COLUMN: Media Player Card (width: 150px)
            Rectangle {
                Layout.preferredWidth: 150
                Layout.fillHeight: true
                radius: 12
                color: "#181825"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    // Album Cover Circle (rotating)
                    Rectangle {
                        Layout.preferredWidth: 68
                        Layout.preferredHeight: 68
                        radius: 34
                        color: theme ? theme.surface : "#313244"
                        border.color: theme ? theme.mauve : "#cba6f7"
                        border.width: 1
                        Layout.alignment: Qt.AlignHCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "󰎆"
                            color: theme ? theme.mauve : "#cba6f7"
                            font.pixelSize: 28
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                        }
                        
                        RotationAnimation on rotation {
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                            duration: 8000
                            running: sysInfo ? sysInfo.media_status === "Playing" : false
                        }
                    }

                    // Song Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: sysInfo ? sysInfo.media_title : "Nothing playing"
                            color: theme ? theme.text : "#cdd6f4"
                            font.pixelSize: 10
                            font.bold: true
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text {
                            text: sysInfo ? sysInfo.media_artist : "Idle"
                            color: theme ? theme.subtext : "#a6adc8"
                            font.pixelSize: 9
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    // Media controls with real interactive button areas
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16
                        
                        Rectangle {
                            width: 24
                            height: 24
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰒮"
                                color: theme ? theme.subtext : "#a6adc8"
                                font.pixelSize: 14
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    Quickshell.execDetached({ command: ["playerctl", "previous"] })
                                }
                            }
                        }
                        
                        Rectangle {
                            width: 28
                            height: 28
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "󰏤" : "󰐊"
                                color: theme ? theme.mauve : "#cba6f7"
                                font.pixelSize: 18
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    Quickshell.execDetached({ command: ["playerctl", "play-pause"] })
                                }
                            }
                        }
                        
                        Rectangle {
                            width: 24
                            height: 24
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "󰒭"
                                color: theme ? theme.subtext : "#a6adc8"
                                font.pixelSize: 14
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    Quickshell.execDetached({ command: ["playerctl", "next"] })
                                }
                            }
                        }
                    }

                    // Cute Paw Animating Bongo Cat Text
                    Text {
                        text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "ฅ^•ﻌ•^ฅ 󰎆" : "ฅ^-ﻌ-^ฅ"
                        font.pixelSize: 11
                        color: theme ? theme.mauve : "#cba6f7"
                        Layout.alignment: Qt.AlignHCenter
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
            }
        }

        // ----------------------------------------------------
        // Media Tab Content (Dedicated player)
        // ----------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            visible: currentTab === "media"

            RowLayout {
                Layout.fillWidth: true
                spacing: 24
                Layout.alignment: Qt.AlignVCenter
                
                Rectangle {
                    width: 100
                    height: 100
                    radius: 12
                    color: "#181825"
                    Layout.alignment: Qt.AlignVCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "󰎆"
                        color: theme ? theme.mauve : "#cba6f7"
                        font.pixelSize: 42
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                    }
                }

                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    Text {
                        text: sysInfo ? sysInfo.media_title : "Nothing playing"
                        color: theme ? theme.text : "#cdd6f4"
                        font.pixelSize: 16
                        font.bold: true
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        text: "Artist: " + (sysInfo ? sysInfo.media_artist : "Idle")
                        color: theme ? theme.subtext : "#a6adc8"
                        font.pixelSize: 12
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                    }

                    Text {
                        text: "Status: " + (sysInfo ? sysInfo.media_status : "Stopped")
                        color: theme ? theme.mauve : "#cba6f7"
                        font.pixelSize: 11
                        font.bold: true
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                    }

                    Item { height: 4 }

                    RowLayout {
                        spacing: 24
                        
                        Text {
                            text: "󰒮 Previous"
                            color: theme ? theme.text : "#cdd6f4"
                            font.pixelSize: 12
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Quickshell.execDetached({ command: ["playerctl", "previous"] })
                            }
                        }
                        Text {
                            text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "󰏤 Pause" : "󰐊 Play"
                            color: theme ? theme.mauve : "#cba6f7"
                            font.pixelSize: 12
                            font.bold: true
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Quickshell.execDetached({ command: ["playerctl", "play-pause"] })
                            }
                        }
                        Text {
                            text: "Next 󰒭"
                            color: theme ? theme.text : "#cdd6f4"
                            font.pixelSize: 12
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Quickshell.execDetached({ command: ["playerctl", "next"] })
                            }
                        }
                    }
                }
            }
        }

        // ----------------------------------------------------
        // Performance Tab Content (Dedicated system diagnosis)
        // ----------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            visible: currentTab === "performance"

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                // Left detail box
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text { text: "CPU Telemetry"; color: theme ? theme.red : "#f38ba8"; font.bold: true; font.pixelSize: 13 }
                        
                        RowLayout {
                            Text { text: "CPU Load:"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11 }
                            Text { text: (sysInfo ? sysInfo.cpu : 0) + "%"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 11 }
                        }
                        RowLayout {
                            Text { text: "CPU Temp:"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11 }
                            Text { text: (sysInfo ? sysInfo.cpu_temp : 0) + "°C"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 11 }
                        }
                    }
                }

                // Right detail box
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text { text: "Memory Telemetry"; color: theme ? theme.peach : "#fab387"; font.bold: true; font.pixelSize: 13 }
                        
                        RowLayout {
                            Text { text: "Memory Load:"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11 }
                            Text { text: (sysInfo ? sysInfo.ram : 0) + "%"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 11 }
                        }
                        RowLayout {
                            Text { text: "Active Used:"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 11 }
                            Text { text: sysInfo ? sysInfo.ram_detail : "0G / 0G"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }
    }
}
