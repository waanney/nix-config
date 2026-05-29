import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: rootTab
    
    property var theme
    property var sysInfo

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 16
            spacing: 24

            // Left: Rotating Vinyl Disc
            Rectangle {
                width: 120
                height: 120
                radius: 60
                color: "#181825"
                border.color: theme ? theme.mauve : "#cba6f7"
                border.width: 2
                Layout.alignment: Qt.AlignVCenter
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: width / 2
                    color: "#11111b"
                    border.color: "#313244"
                    border.width: 1
                    
                    RotationAnimator on rotation {
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 8000
                        running: sysInfo ? sysInfo.media_status === "Playing" : false
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 80
                        height: 80
                        radius: 40
                        color: "#1e1e2e"
                        
                        Rectangle {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            radius: 16
                            color: theme ? theme.mauve : "#cba6f7"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "󰎆"
                                color: "#11111b"
                                font.pixelSize: 18
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                        }
                    }
                }
            }

            // Middle: Controls & Track Info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: sysInfo ? sysInfo.media_title : "Nothing playing"
                    color: theme ? theme.text : "#cdd6f4"
                    font.pixelSize: 15
                    font.bold: true
                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                Text {
                    text: sysInfo ? sysInfo.media_artist : "Idle"
                    color: theme ? theme.subtext : "#a6adc8"
                    font.pixelSize: 11
                    font.family: theme ? theme.fontFamily : "Iosevka NF"
                }

                Item { height: 4 }

                // Controls Row
                RowLayout {
                    spacing: 16
                    
                    Text {
                        text: "󰒮"
                        color: theme ? theme.text : "#cdd6f4"
                        font.pixelSize: 18
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached({ command: ["playerctl", "previous"] })
                        }
                    }
                    
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: theme ? theme.mauve : "#cba6f7"
                        
                        Text {
                            anchors.centerIn: parent
                            text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "󰏤" : "󰐊"
                            color: "#11111b"
                            font.pixelSize: 18
                            font.bold: true
                            font.family: theme ? theme.fontFamily : "Iosevka NF"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached({ command: ["playerctl", "play-pause"] })
                        }
                    }
                    
                    Text {
                        text: "󰒭"
                        color: theme ? theme.text : "#cdd6f4"
                        font.pixelSize: 18
                        font.family: theme ? theme.fontFamily : "Iosevka NF"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached({ command: ["playerctl", "next"] })
                        }
                    }
                }

                Item { height: 4 }

                // Progress Bar
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 4
                        color: theme ? theme.surface : "#313244"
                        radius: 2
                        
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width * (sysInfo && sysInfo.media_length > 0 ? sysInfo.media_position / sysInfo.media_length : 0)
                            color: theme ? theme.mauve : "#cba6f7"
                            radius: 2
                            Behavior on width { NumberAnimation { duration: 300 } }
                        }
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: {
                                var pos = sysInfo ? sysInfo.media_position : 0;
                                var m = Math.floor(pos / 60);
                                var s = pos % 60;
                                return m + ":" + (s < 10 ? "0" + s : s);
                            }
                            color: theme ? theme.subtext : "#a6adc8"
                            font.pixelSize: 9
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: {
                                var len = sysInfo ? sysInfo.media_length : 0;
                                var m = Math.floor(len / 60);
                                var s = len % 60;
                                return m + ":" + (s < 10 ? "0" + s : s);
                            }
                            color: theme ? theme.subtext : "#a6adc8"
                            font.pixelSize: 9
                        }
                    }
                }

                // Source Pill (dynamic based on active player)
                RowLayout {
                    spacing: 8
                    
                    Rectangle {
                        height: 24
                        width: 90
                        radius: 12
                        color: {
                            var src = sysInfo && sysInfo.media_source ? sysInfo.media_source : "None";
                            if (src.toLowerCase().indexOf("spotify") !== -1) return "#1db954";
                            if (src.toLowerCase().indexOf("firefox") !== -1 || src.toLowerCase().indexOf("zen") !== -1) return "#ff7139";
                            if (src.toLowerCase().indexOf("vlc") !== -1) return "#ff8800";
                            if (src.toLowerCase().indexOf("chromium") !== -1) return "#4285f4";
                            return theme ? theme.surface : "#313244";
                        }
                        
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: {
                                    var src = sysInfo && sysInfo.media_source ? sysInfo.media_source : "None";
                                    if (src.toLowerCase().indexOf("spotify") !== -1) return "󰓇";
                                    if (src.toLowerCase().indexOf("firefox") !== -1) return "󰈹";
                                    if (src.toLowerCase().indexOf("zen") !== -1) return "󰈹";
                                    if (src.toLowerCase().indexOf("vlc") !== -1) return "󰕼";
                                    if (src.toLowerCase().indexOf("chromium") !== -1) return "";
                                    return "󰎆";
                                }
                                color: "#11111b"
                                font.pixelSize: 12
                                font.family: theme ? theme.fontFamily : "Iosevka NF"
                            }
                            Text {
                                text: {
                                    var src = sysInfo && sysInfo.media_source ? sysInfo.media_source : "None";
                                    if (src === "None") return "No Player";
                                    return src.charAt(0).toUpperCase() + src.slice(1);
                                }
                                color: "#11111b"
                                font.bold: true
                                font.pixelSize: 10
                            }
                        }
                    }
                }
            }

            // Right: Cute Paws Bongo Cat
            ColumnLayout {
                Layout.preferredWidth: 100
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                
                Text {
                    text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "ฅ^•ﻌ•^ฅ 󰎆" : "ฅ^-ﻌ-^ฅ"
                    color: theme ? theme.mauve : "#cba6f7"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: (sysInfo ? sysInfo.media_status === "Playing" : false) ? "  /|_/| \n ( •. •)\n /|   |~" : "  /|_/| \n ( -_ -)\n /|   |~"
                    color: theme ? theme.text : "#cdd6f4"
                    font.pixelSize: 12
                    font.family: "monospace"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
