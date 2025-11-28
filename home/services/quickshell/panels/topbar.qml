import Quickshell
import Quickshell.Widgets
import QtQuick

PanelWindow {
  id: root

  property bool hovered: false

  anchors {
    top: true
    left: true
    right: true
  }

  color: "transparent"

  implicitHeight: hovered ? 340 : 8
  Behavior on implicitHeight { NumberAnimation { duration: 200 } }
  
  // Top border - always visible, tràn viền
  Rectangle {
    id: topBorder
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      leftMargin: 0
      rightMargin: 0
    }
    height: 8
    color: "#5a5650"
    radius: 4
    z: 1
  }
  
  // Left corner curve connector - connects top border to left border
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
      // Arc from top-left corner
      ctx.arc(16, 0, 16, 0, Math.PI / 2, false);
      ctx.stroke();
    }
  }
  
  // Right corner curve connector - connects top border to right border
  Canvas {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 0
    anchors.rightMargin: 0
    width: 16
    height: 16
    z: 1
    
    onPaint: {
      var ctx = getContext("2d");
      ctx.strokeStyle = "#5a5650";
      ctx.lineWidth = 2;
      ctx.beginPath();
      // Arc from top-right corner
      ctx.arc(0, 0, 16, Math.PI / 2, Math.PI, false);
      ctx.stroke();
    }
  }
  
  // Background with rounded corners - only visible on hover
  Rectangle {
    id: backdrop
    anchors {
      fill: parent
      leftMargin: 4
      rightMargin: 4
      topMargin: 4
      bottomMargin: 4
    }
    radius: 12
    color: "#e6e1dc" // Light beige background
    opacity: hovered ? 0.98 : 0
    clip: true
    Behavior on opacity { NumberAnimation { duration: 200 } }
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

  MouseArea {
    id: hoverArea
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
    }
    height: 20
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    z: 10
    onEntered: hovered = true
    onExited: hovered = false
  }
}
