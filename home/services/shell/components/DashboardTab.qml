import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: rootTab
    
    property var theme
    property var sysInfo
    
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

    RowLayout {
        anchors.fill: parent
        spacing: 12

        // LEFT SECTION: Covers Clock, Weather, Profile, Calendar, Sliders
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // ROW 1: Weather (Left) + System Info (Right)
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 75
                Layout.fillHeight: false
                spacing: 10

                // Weather card
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
                            Text { text: sysInfo && sysInfo.weather_temp ? sysInfo.weather_temp : "--°C"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 13; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                            Text { text: sysInfo && sysInfo.weather_desc ? sysInfo.weather_desc : "Unknown"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
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
                                text: ""
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
                                Text { text: sysInfo && sysInfo.os_name ? sysInfo.os_name : "Linux"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                            }
                            RowLayout {
                                spacing: 4
                                Text { text: "󰕮"; color: theme ? theme.blue : "#89b4fa"; font.pixelSize: 9; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                Text { text: sysInfo && sysInfo.wm_name ? sysInfo.wm_name : "Unknown"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
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

            // ROW 2: Clock (Left) + Calendar (Middle) + Sliders (Right)
            RowLayout {
                id: row2Layout
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Vertical Large Clock Card (optimized to width: 25%)
                Rectangle {
                    Layout.preferredWidth: (row2Layout.width - row2Layout.spacing * 2) * 0.25
                    Layout.fillWidth: true
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

                // Calendar Card (Middle - optimized to width: 50%)
                Rectangle {
                    Layout.preferredWidth: (row2Layout.width - row2Layout.spacing * 2) * 0.50
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
                                    font.pixelSize: 12
                                    font.bold: true
                                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        // Fully flexible and responsive GridLayout
                        GridLayout {
                            columns: 7
                            rowSpacing: 2
                            columnSpacing: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            Repeater {
                                model: getCalendarDays()
                                delegate: Rectangle {
                                    implicitWidth: 24
                                    implicitHeight: 16
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
                                        font.pixelSize: 11
                                        font.bold: modelData.today
                                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                                    }
                                }
                            }
                        }
                    }
                }

                // Vertical System Telemetry Sliders (Right - optimized to width: 25%)
                Rectangle {
                    Layout.preferredWidth: (row2Layout.width - row2Layout.spacing * 2) * 0.25
                    Layout.fillWidth: true
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
}
