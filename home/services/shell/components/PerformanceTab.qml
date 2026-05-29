import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: rootTab
    
    property var theme
    property var sysInfo

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // LEFT COLUMN (CPU, GPU, Memory, Storage, Network)
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // ROW 1: CPU & GPU
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                Layout.fillHeight: false
                spacing: 10

                // CPU Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1
                    clip: true

                    // Left Accent Accent Pill (inset vertical pill with rounded corners)
                    Rectangle {
                        width: 4
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        color: theme ? theme.blue : "#89b4fa"
                        radius: 2
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            RowLayout {
                                spacing: 4
                                Text { text: ""; color: theme ? theme.blue : "#89b4fa"; font.pixelSize: 12; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                Text {
                                    text: "CPU - " + (sysInfo && sysInfo.cpu_name ? sysInfo.cpu_name : "Generic CPU")
                                    color: theme ? theme.text : "#cdd6f4"
                                    font.bold: true
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            Item { Layout.fillHeight: true }

                            Text {
                                text: sysInfo ? (sysInfo.cpu_temp + "°C Temp") : "68°C Temp"
                                color: theme ? theme.subtext : "#a6adc8"
                                font.pixelSize: 9
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 4
                                color: "#313244"
                                radius: 2
                                Rectangle {
                                    width: parent.width * ((sysInfo ? sysInfo.cpu : 4) / 100.0)
                                    height: parent.height
                                    color: theme ? theme.blue : "#89b4fa"
                                    radius: 2
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            spacing: 2
                            Text { text: "Usage"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; Layout.alignment: Qt.AlignRight }
                            Text {
                                text: (sysInfo ? sysInfo.cpu : 4) + "%"
                                color: theme ? theme.blue : "#89b4fa"
                                font.bold: true
                                font.pixelSize: 16
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }
                }

                // GPU Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1
                    clip: true

                    // Left Accent Accent Pill (inset vertical pill with rounded corners)
                    Rectangle {
                        width: 4
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        color: theme ? theme.green : "#a6e3a1"
                        radius: 2
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            RowLayout {
                                spacing: 4
                                Text { text: "󰢮"; color: theme ? theme.green : "#a6e3a1"; font.pixelSize: 12; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                Text {
                                    text: "GPU - " + (sysInfo && sysInfo.gpu_name ? sysInfo.gpu_name : "Generic GPU")
                                    color: theme ? theme.text : "#cdd6f4"
                                    font.bold: true
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            Item { Layout.fillHeight: true }

                            Text {
                                text: sysInfo ? ((sysInfo.cpu_temp > 5 ? sysInfo.cpu_temp - 5 : 45) + "°C Temp") : "59°C Temp"
                                color: theme ? theme.subtext : "#a6adc8"
                                font.pixelSize: 9
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 4
                                color: "#313244"
                                radius: 2
                                Rectangle {
                                    width: parent.width * ((sysInfo ? (sysInfo.cpu > 1 ? sysInfo.cpu - 1 : 1) : 4) / 100.0)
                                    height: parent.height
                                    color: theme ? theme.green : "#a6e3a1"
                                    radius: 2
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            spacing: 2
                            Text { text: "Usage"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; Layout.alignment: Qt.AlignRight }
                            Text {
                                text: (sysInfo ? (sysInfo.cpu > 1 ? sysInfo.cpu - 1 : 1) : 4) + "%"
                                color: theme ? theme.green : "#a6e3a1"
                                font.bold: true
                                font.pixelSize: 16
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }
                }
            }

            // ROW 2: Memory, Storage, Network
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Memory Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        RowLayout {
                            spacing: 4
                            Text { text: "󰘚"; color: theme ? theme.mauve : "#cba6f7"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                            Text { text: "Memory"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9 }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            Item {
                                width: 54
                                height: 54
                                anchors.centerIn: parent

                                Shape {
                                    anchors.fill: parent
                                    ShapePath {
                                        strokeColor: "#313244"
                                        strokeWidth: 4
                                        fillColor: "transparent"
                                        capStyle: ShapePath.RoundCap
                                        PathAngleArc {
                                            centerX: 27; centerY: 27
                                            radiusX: 23; radiusY: 23
                                            startAngle: 135; sweepAngle: 270
                                        }
                                    }
                                }

                                Shape {
                                    anchors.fill: parent
                                    ShapePath {
                                        strokeColor: theme ? theme.mauve : "#cba6f7"
                                        strokeWidth: 4
                                        fillColor: "transparent"
                                        capStyle: ShapePath.RoundCap
                                        PathAngleArc {
                                            centerX: 27; centerY: 27
                                            radiusX: 23; radiusY: 23
                                            startAngle: 135
                                            sweepAngle: 270 * ((sysInfo ? sysInfo.ram : 14) / 100.0)
                                        }
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: (sysInfo ? sysInfo.ram : 14) + "%"
                                    color: theme ? theme.text : "#cdd6f4"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Text {
                            text: sysInfo ? sysInfo.ram_detail : "3.3 / 22 GiB"
                            color: theme ? theme.subtext : "#a6adc8"
                            font.pixelSize: 8
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Storage Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        RowLayout {
                            spacing: 4
                            Text { text: "󰋊"; color: theme ? theme.blue : "#89b4fa"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                            Text { text: "Storage - nvme0n1"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9 }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            Item {
                                width: 54
                                height: 54
                                anchors.centerIn: parent

                                Shape {
                                    anchors.fill: parent
                                    ShapePath {
                                        strokeColor: "#313244"
                                        strokeWidth: 4
                                        fillColor: "transparent"
                                        capStyle: ShapePath.RoundCap
                                        PathAngleArc {
                                            centerX: 27; centerY: 27
                                            radiusX: 23; radiusY: 23
                                            startAngle: 135; sweepAngle: 270
                                        }
                                    }
                                }

                                Shape {
                                    anchors.fill: parent
                                    ShapePath {
                                        strokeColor: theme ? theme.blue : "#89b4fa"
                                        strokeWidth: 4
                                        fillColor: "transparent"
                                        capStyle: ShapePath.RoundCap
                                        PathAngleArc {
                                            centerX: 27; centerY: 27
                                            radiusX: 23; radiusY: 23
                                            startAngle: 135
                                            sweepAngle: 270 * 0.11
                                        }
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "11%"
                                    color: theme ? theme.text : "#cdd6f4"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Text {
                            text: "21.9 / 191 GiB"
                            color: theme ? theme.subtext : "#a6adc8"
                            font.pixelSize: 8
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Network Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        ColumnLayout {
                            spacing: 2
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            
                            RowLayout {
                                spacing: 4
                                Text { text: "󰖩"; color: theme ? theme.mauve : "#cba6f7"; font.pixelSize: 10; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                Text { text: "Network"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9 }
                            }

                            Item { Layout.fillHeight: true }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰵚"; color: theme ? theme.mauve : "#cba6f7"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: "Download"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8 }
                                }
                                Item { Layout.fillWidth: true }
                                Text { text: "222.5 B/s"; color: theme ? theme.mauve : "#cba6f7"; font.bold: true; font.pixelSize: 8 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰵘"; color: theme ? theme.mauve : "#cba6f7"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: "Upload"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8 }
                                }
                                Item { Layout.fillWidth: true }
                                Text { text: "203.9 B/s"; color: theme ? theme.mauve : "#cba6f7"; font.bold: true; font.pixelSize: 8 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰒍"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                                    Text { text: "Total"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8 }
                                }
                                Item { Layout.fillWidth: true }
                                Text { text: "↓17.8MB ↑530.4KB"; color: theme ? theme.subtext : "#a6adc8"; font.pixelSize: 8 }
                            }
                        }

                        // Elegant Vector Single-Peak Network Graph
                        Item {
                            Layout.preferredWidth: 35
                            Layout.fillHeight: true
                            
                            Shape {
                                anchors.fill: parent
                                ShapePath {
                                    strokeColor: theme ? theme.mauve : "#cba6f7"
                                    strokeWidth: 1.5
                                    fillColor: "#22cba6f7"
                                    startX: 0; startY: 45
                                    PathLine { x: 10; y: 45 }
                                    PathLine { x: 23; y: 8 }
                                    PathLine { x: 27; y: 8 }
                                    PathLine { x: 35; y: 45 }
                                }
                            }
                        }
                    }
                }
            }
        }

        // RIGHT COLUMN (Battery Card)
        Rectangle {
            Layout.preferredWidth: 70
            Layout.fillHeight: true
            radius: 12
            color: "#181825"
            border.color: "#313244"
            border.width: 1
            clip: true

            // Fluid battery level background fill matching the reference design
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.height * ((sysInfo ? sysInfo.bat_cap : 91) / 100.0)
                color: theme ? theme.green : "#a6e3a1"
                opacity: 0.15
                radius: 12
                Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 4

                // Top part: Battery header
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    Text { text: "󰁹"; color: theme ? theme.green : "#a6e3a1"; font.pixelSize: 11; font.family: theme ? theme.fontFamily : "Iosevka NF" }
                    Text { text: "Battery"; color: theme ? theme.text : "#cdd6f4"; font.bold: true; font.pixelSize: 9 }
                }

                Item { Layout.fillHeight: true }

                // Bottom part: Large percentage & status text
                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    
                    Text {
                        text: (sysInfo ? sysInfo.bat_cap : 91) + "%"
                        color: theme ? theme.green : "#a6e3a1"
                        font.bold: true
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: sysInfo ? sysInfo.bat_status : "Charging"
                        color: theme ? theme.subtext : "#a6adc8"
                        font.pixelSize: 8
                        Layout.alignment: Qt.AlignHCenter
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
