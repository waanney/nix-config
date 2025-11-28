import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: root
  property bool hovered: hoverArea.containsMouse
  
  anchors {
    top: true
    bottom: true
    left: true
  }
  width: 60
  color: "transparent"
  
  // Background with rounded corners
  Rectangle {
    id: background
    anchors.fill: parent
    anchors.topMargin: 8
    anchors.bottomMargin: 8
    anchors.rightMargin: 8
    color: "#e6e1dc" // Light beige background
    radius: 12
    clip: true
    
    // Shadow effect
    Rectangle {
      anchors.fill: parent
      anchors.leftMargin: -1
      anchors.rightMargin: -1
      anchors.topMargin: -1
      anchors.bottomMargin: -1
      color: "transparent"
      border.color: "#00000010"
      border.width: 1
      radius: 13
      z: -1
    }
  }
  
  ColumnLayout {
    anchors.fill: background
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    spacing: 10

    // Top: Triangle icon
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 12
      
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: "▲"
        color: "#8b8680"
        font.pixelSize: 8
      }
    }

    // Workspace position indicator (1, 2, 3)
    Item {
      id: workspacePositionArea
      Layout.fillWidth: true
      Layout.preferredHeight: 20
      property bool areaHovered: positionMouseArea.containsMouse
      
      Row {
        anchors.centerIn: parent
        spacing: 5
        
        // Workspace 1 indicator (active - pink/red)
        Rectangle {
          width: 5
          height: 5
          radius: 2.5
          color: "#d4a574" // Light pink/beige active
        }
        
        // Workspace 2 indicator (inactive)
        Rectangle {
          width: 5
          height: 5
          radius: 2.5
          color: "#c4b5a0" // Light grey inactive
        }
        
        // Workspace 3 indicator (inactive)
        Rectangle {
          width: 5
          height: 5
          radius: 2.5
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

    // Small icons section
    Column {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      spacing: 8
      
      // Document icon
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "󰈙"
        color: "#8b8680"
        font.pixelSize: 14
      }
      
      // List icon
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "󰝒"
        color: "#8b8680"
        font.pixelSize: 14
      }
      
      // Dots
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "⋯"
        color: "#8b8680"
        font.pixelSize: 12
      }
    }

    // Spacer
    Item { Layout.fillHeight: true }

    // "Desktop" text rotated vertically
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      
      Text {
        anchors.centerIn: parent
        text: "Desktop"
        color: "#8b8680"
        font.pixelSize: 11
        rotation: -90
        transformOrigin: Item.Center
      }
    }

    // Spacer
    Item { Layout.fillHeight: true }

    // App icons: Discord, Spotify, Calendar
    Column {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      spacing: 10
      
      // Discord
      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 24
        height: 24
        radius: 12
        color: "#5865f2" // Discord blue
        
        Text {
          anchors.centerIn: parent
          text: "󰙯"
          color: "#ffffff"
          font.pixelSize: 14
        }
      }
      
      // Spotify
      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 24
        height: 24
        radius: 12
        color: "#1db954" // Spotify green
        
        Text {
          anchors.centerIn: parent
          text: "󰓇"
          color: "#ffffff"
          font.pixelSize: 14
        }
      }
      
      // Calendar with time
      Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 24
        height: 32
        
        Rectangle {
          anchors.centerIn: parent
          width: 24
          height: 24
          radius: 4
          color: "#1db954" // Green calendar
          
          Text {
            anchors.centerIn: parent
            text: "󰃭"
            color: "#ffffff"
            font.pixelSize: 12
          }
        }
        
        Column {
          anchors.top: parent.bottom
          anchors.topMargin: 2
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: 0
          
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "21"
            color: "#8b8680"
            font.pixelSize: 8
          }
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "40"
            color: "#8b8680"
            font.pixelSize: 8
          }
        }
      }
    }

    // Spacer
    Item { Layout.fillHeight: true }

    // System info: WiFi, Battery, Power
    Column {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      spacing: 12
      
      // WiFi
      Item {
        id: wifiItem
        width: parent.width
        height: 20
        property bool itemHovered: wifiMouseArea.containsMouse
        
        Text {
          id: networkText
          anchors.centerIn: parent
          color: "#8b8680"
          font.pixelSize: 16
          text: "󰤨"
          
          Component.onCompleted: {
            const proc = Qt.createQmlObject('
              import Quickshell
              Process {
                command: ["sh", "-c", "ip link show | grep -q \"state UP\" && echo \"up\" || echo \"down\""]
                running: true
                interval: 5000
              }
            ', networkText);
            proc.onStdout = (data) => {
              if (data.trim() === "up") {
                networkText.text = "󰤨";
              } else {
                networkText.text = "󰤭";
              }
            };
          }
        }
        
        MouseArea {
          id: wifiMouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
          z: 5
        }
        
        // WiFi tooltip
        Rectangle {
          anchors.left: parent.right
          anchors.leftMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          width: wifiTooltip.visible ? wifiTooltip.width + 16 : 0
          height: wifiTooltip.visible ? wifiTooltip.height + 8 : 0
          color: "#2a2520"
          border.color: "#d4a57440"
          border.width: 1
          radius: 4
          visible: wifiItem.itemHovered
          opacity: visible ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 100 } }
          
          Column {
            id: wifiTooltip
            anchors.centerIn: parent
            spacing: 2
            padding: 4
            
            Text {
              text: "Connected to: Network"
              color: "#e6e1dc"
              font.pixelSize: 10
            }
            Text {
              text: "Strength: 67/100"
              color: "#c4b5a0"
              font.pixelSize: 9
            }
            Text {
              text: "Frequency: 5500 MHz"
              color: "#c4b5a0"
              font.pixelSize: 9
            }
          }
        }
      }
      
      // Battery
      Item {
        id: batteryItem
        width: parent.width
        height: 20
        property bool itemHovered: batteryMouseArea.containsMouse
        
        Text {
          id: batteryText
          anchors.centerIn: parent
          color: "#8b8680"
          font.pixelSize: 16
          text: "󰁹"
          
          Component.onCompleted: {
            const proc = Qt.createQmlObject('
              import Quickshell
              Process {
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo \"0\""]
                running: true
                interval: 5000
              }
            ', batteryText);
            proc.onStdout = (data) => {
              const capacity = parseInt(data.trim());
              if (capacity >= 90) {
                batteryText.text = "󰁹";
              } else if (capacity >= 70) {
                batteryText.text = "󰂀";
              } else if (capacity >= 50) {
                batteryText.text = "󰁾";
              } else if (capacity >= 30) {
                batteryText.text = "󰁻";
              } else if (capacity >= 10) {
                batteryText.text = "󰁺";
              } else {
                batteryText.text = "󰁹";
              }
            };
          }
        }
        
        MouseArea {
          id: batteryMouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
          z: 5
        }
        
        // Battery tooltip
        Rectangle {
          anchors.left: parent.right
          anchors.leftMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          width: batteryTooltip.visible ? batteryTooltip.width + 16 : 0
          height: batteryTooltip.visible ? batteryTooltip.height + 8 : 0
          color: "#2a2520"
          border.color: "#d4a57440"
          border.width: 1
          radius: 4
          visible: batteryItem.itemHovered
          opacity: visible ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 100 } }
          
          Column {
            id: batteryTooltip
            anchors.centerIn: parent
            spacing: 2
            padding: 4
            
            Text {
              text: "Battery: 85%"
              color: "#e6e1dc"
              font.pixelSize: 10
            }
            Text {
              text: "Charging"
              color: "#c4b5a0"
              font.pixelSize: 9
            }
          }
        }
      }
      
      // Power button (bottom)
      Item {
        id: powerItem
        width: parent.width
        height: 20
        
        Text {
          id: powerButton
          anchors.centerIn: parent
          text: "󰐥"
          color: "#8b8680"
          font.pixelSize: 16
          
          MouseArea {
            anchors.fill: parent
            onClicked: {
              // Power menu action - placeholder
              console.log("Power button clicked");
            }
          }
        }
      }
    }
  }

  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    z: 1
  }
}



