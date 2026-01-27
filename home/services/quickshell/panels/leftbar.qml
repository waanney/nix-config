import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../components"

PanelWindow {
  id: root
  
  anchors {
    top: true
    bottom: true
    left: true
  }

  property bool hovered: false
  property bool isExpanded: hovered
  
  MouseArea {
      id: hoverArea
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.NoButton
      z: 10
      onEntered: root.hovered = true
      onExited: root.hovered = false
  }

  // Animate the width
  implicitWidth: isExpanded ? 60 : 16
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 300
      easing.type: Easing.OutExpo
    }
  }

  color: "transparent"

  // Input capture layer - ensures mouse events are caught even in transparent areas
  Rectangle {
      anchors.fill: parent
      color: "#01000000" // Almost transparent but opaque to input
      z: -100 // Behind everything
  }

  property var currentDate: new Date()
  Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: root.currentDate = new Date()
  }
  
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
      ctx.arc(0, 16, 16, 3 * Math.PI / 2, 2 * Math.PI, false);
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
    anchors.rightMargin: 0
    color: "#e6e1dc" // Light beige background
    radius: 12
    clip: true
    z: 0

    opacity: isExpanded ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
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

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.AllButtons
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
    NixLogo {}

    // Workspace position indicator (1, 2, 3)
    WorkspaceControl {}

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

          MouseArea {
            anchors.fill: parent
            onClicked: {
               var proc = Qt.createQmlObject('import Quickshell; Process { command: ["niri", "msg", "action", "spawn", "vesktop"] }', parent);
               proc.running = true;
            }
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
            text: Qt.formatDateTime(root.currentDate, "hh")
            color: "#5a5650"
            font.pixelSize: 9
          }
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(root.currentDate, "mm")
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
      NetworkIndicator {}
      
      // Battery
      BatteryIndicator {}
      
      // Bluetooth
      BluetoothIndicator {}
      
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
      
      // Power Menu
      PowerMenu {}
    }
  }
}
