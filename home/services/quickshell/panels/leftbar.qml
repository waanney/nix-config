import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: root
  
  anchors {
    top: true
    bottom: true
    left: true
  }
  implicitWidth: 60
  color: "transparent"
  
  // Left border - always visible
  Rectangle {
    id: leftBorder
    anchors {
      top: parent.top
      bottom: parent.bottom
      left: parent.left
      topMargin: 0
      bottomMargin: 0
    }
    width: 4
    color: "#5a5650"
    radius: 2
    z: 1
  }
  
  // Top corner curve connector - connects left border to top border
  Canvas {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.topMargin: 0
    anchors.leftMargin: 0
    width: 16
    height: 16
    z: 1
    
    onPaint: {
      var ctx = getContext("2d");
      ctx.strokeStyle = "#5a5650";
      ctx.lineWidth = 2;
      ctx.beginPath();
      // Arc from top-left corner, connecting left border to top border
      ctx.arc(0, 16, 16, Math.PI / 2, Math.PI, false);
      ctx.stroke();
    }
  }
  
  // Bottom corner curve connector - connects left border to bottom border
  Canvas {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    width: 16
    height: 16
    z: 1
    
    onPaint: {
      var ctx = getContext("2d");
      ctx.strokeStyle = "#5a5650";
      ctx.lineWidth = 2;
      ctx.beginPath();
      // Arc from bottom-left corner, connecting left border to bottom border
      ctx.arc(0, 0, 16, 0, Math.PI / 2, false);
      ctx.stroke();
    }
  }
  
  // Background with rounded corners - always visible
  Rectangle {
    id: background
    anchors.fill: parent
    anchors.topMargin: 4
    anchors.bottomMargin: 4
    anchors.rightMargin: 4
    color: "#e6e1dc" // Light beige background
    radius: 12
    clip: true
    z: 0
    
    // Shadow effect
    Rectangle {
      anchors.fill: parent
      anchors.leftMargin: 2
      anchors.rightMargin: -2
      anchors.topMargin: 2
      anchors.bottomMargin: -2
      color: "transparent"
      border.color: "#00000020"
      border.width: 1
      radius: 14
      z: -1
    }
  }
  
  ColumnLayout {
    anchors.fill: background
    anchors.topMargin: 14
    anchors.bottomMargin: 14
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    spacing: 12

    // Top: NixOS logo
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 24
      
      // NixOS logo - try to load from system, fallback to geometric shape
      Image {
        id: nixosLogo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 18
        height: 18
        source: "/run/current-system/sw/share/pixmaps/nixos.svg"
        fillMode: Image.PreserveAspectFit
        visible: status === Image.Ready
        
        onStatusChanged: {
          if (status === Image.Error) {
            // Try alternative paths
            source = "/nix/var/nix/profiles/system/share/pixmaps/nixos.svg";
          }
        }
      }
      
      // Fallback: NixOS geometric logo shape
      Canvas {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 18
        height: 18
        visible: nixosLogo.status !== Image.Ready
        
        onPaint: {
          var ctx = getContext("2d");
          ctx.clearRect(0, 0, width, height);
          ctx.fillStyle = "#5a5650";
          
          // Draw NixOS logo shape (simplified geometric pattern)
          ctx.beginPath();
          // Top triangle
          ctx.moveTo(9, 2);
          ctx.lineTo(13, 8);
          ctx.lineTo(5, 8);
          ctx.closePath();
          ctx.fill();
          
          // Bottom left
          ctx.beginPath();
          ctx.moveTo(5, 8);
          ctx.lineTo(9, 14);
          ctx.lineTo(5, 16);
          ctx.closePath();
          ctx.fill();
          
          // Bottom right
          ctx.beginPath();
          ctx.moveTo(13, 8);
          ctx.lineTo(13, 16);
          ctx.lineTo(9, 14);
          ctx.closePath();
          ctx.fill();
        }
      }
    }

    // Workspace position indicator (1, 2, 3)
    Item {
      id: workspacePositionArea
      Layout.fillWidth: true
      Layout.preferredHeight: 22
      property bool areaHovered: positionMouseArea.containsMouse
      
      Row {
        anchors.centerIn: parent
        spacing: 6
        
        // Workspace 1 indicator (active - darker beige/brown)
        Rectangle {
          width: 6
          height: 6
          radius: 3
          color: "#b89a7a" // Darker beige/brown active
        }
        
        // Workspace 2 indicator (inactive)
        Rectangle {
          width: 6
          height: 6
          radius: 3
          color: "#c4b5a0" // Light grey inactive
        }
        
        // Workspace 3 indicator (inactive)
        Rectangle {
          width: 6
          height: 6
          radius: 3
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
      spacing: 10
      
      // Document icon
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "󰈙"
        color: "#5a5650"
        font.pixelSize: 15
      }
      
      // List icon
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "󰝒"
        color: "#5a5650"
        font.pixelSize: 15
      }
      
      // Dots
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "⋯"
        color: "#5a5650"
        font.pixelSize: 13
      }
    }

    // Spacer
    Item { Layout.fillHeight: true }

    // "Desktop" text rotated vertically
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 90
      
      Text {
        anchors.centerIn: parent
        text: "Desktop"
        color: "#5a5650"
        font.pixelSize: 12
        font.weight: Font.Medium
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
      spacing: 12
      
      // Discord with notification dot
      Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 26
        height: 26
        
        Rectangle {
          anchors.centerIn: parent
          width: 26
          height: 26
          radius: 13
          color: "#5865f2" // Discord blue
          
          Text {
            anchors.centerIn: parent
            text: "󰙯"
            color: "#ffffff"
            font.pixelSize: 15
          }
        }
        
        // Notification dot
        Rectangle {
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.rightMargin: -2
          anchors.topMargin: -2
          width: 8
          height: 8
          radius: 4
          color: "#ef4444" // Red notification dot
          border.color: "#e6e1dc"
          border.width: 1.5
        }
      }
      
      // Spotify
      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 26
        height: 26
        radius: 13
        color: "#1db954" // Spotify green
        
        Text {
          anchors.centerIn: parent
          text: "󰓇"
          color: "#ffffff"
          font.pixelSize: 15
        }
      }
      
      // Calendar with time
      Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 26
        height: 36
        
        Rectangle {
          anchors.centerIn: parent
          width: 26
          height: 26
          radius: 5
          color: "#1db954" // Green calendar
          
          Text {
            anchors.centerIn: parent
            text: "󰃭"
            color: "#ffffff"
            font.pixelSize: 13
          }
        }
        
        Column {
          anchors.top: parent.bottom
          anchors.topMargin: 3
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: 1
          
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "21"
            color: "#5a5650"
            font.pixelSize: 9
          }
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "40"
            color: "#5a5650"
            font.pixelSize: 9
          }
        }
      }
    }

    // Spacer
    Item { Layout.fillHeight: true }

    // System info: WiFi, Battery, Bluetooth, Rocket, Power
    Column {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      spacing: 14
      
      // WiFi
      Item {
        id: wifiItem
        width: parent.width
        height: 22
        property bool itemHovered: wifiMouseArea.containsMouse
        
        Text {
          id: networkText
          anchors.centerIn: parent
          color: "#5a5650"
          font.pixelSize: 17
          text: "󰤨"
          
          Component.onCompleted: {
            const proc = Qt.createQmlObject(`
              import Quickshell
              Process {
                command: ["sh", "-c", "ip link show | grep -q 'state UP' && echo 'up' || echo 'down'"]
                running: true
                interval: 5000
              }
            `, networkText);
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
        height: 22
        property bool itemHovered: batteryMouseArea.containsMouse
        
        Text {
          id: batteryText
          anchors.centerIn: parent
          color: "#5a5650"
          font.pixelSize: 17
          text: "󰁹"
          
          Component.onCompleted: {
            const proc = Qt.createQmlObject(`
              import Quickshell
              Process {
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo '0'"]
                running: true
                interval: 5000
              }
            `, batteryText);
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
      
      // Bluetooth
      Item {
        id: bluetoothItem
        width: parent.width
        height: 22
        property bool itemHovered: bluetoothMouseArea.containsMouse
        
        Text {
          id: bluetoothText
          anchors.centerIn: parent
          color: "#5a5650"
          font.pixelSize: 17
          text: "󰂯"
        }
        
        MouseArea {
          id: bluetoothMouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
          z: 5
        }
      }
      
      // Rocket
      Item {
        id: rocketItem
        width: parent.width
        height: 22
        property bool itemHovered: rocketMouseArea.containsMouse
        
        Text {
          id: rocketText
          anchors.centerIn: parent
          color: "#5a5650"
          font.pixelSize: 17
          text: "󰓹"
        }
        
        MouseArea {
          id: rocketMouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
          z: 5
        }
      }
      
      // Power button (bottom) - red color
      Item {
        id: powerItem
        width: parent.width
        height: 22
        
        Text {
          id: powerButton
          anchors.centerIn: parent
          text: "󰐥"
          color: "#dc2626" // Red color
          font.pixelSize: 17
          
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
}
