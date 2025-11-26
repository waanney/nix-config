import Quickshell
import Quickshell.Widgets
import QtQuick

PanelWindow {
  id: root
  
  anchors {
    bottom: true
    left: true
    right: true
  }
  implicitHeight: 8
  color: "transparent"
  
  // Bottom border - always visible, tràn viền
  Rectangle {
    id: bottomBorder
    anchors {
      bottom: parent.bottom
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
  
  // Left corner curve connector - connects bottom border to left border
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
      // Arc from bottom-left corner
      ctx.arc(16, 16, 16, Math.PI, Math.PI * 1.5, false);
      ctx.stroke();
    }
  }
  
  // Right corner curve connector - connects bottom border to right border
  Canvas {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: 0
    anchors.rightMargin: 0
    width: 16
    height: 16
    z: 1
    
    onPaint: {
      var ctx = getContext("2d");
      ctx.strokeStyle = "#5a5650";
      ctx.lineWidth = 2;
      ctx.beginPath();
      // Arc from bottom-right corner
      ctx.arc(0, 16, 16, Math.PI * 1.5, 0, false);
      ctx.stroke();
    }
  }
}

