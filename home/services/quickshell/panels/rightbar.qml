import Quickshell
import Quickshell.Widgets
import QtQuick

PanelWindow {
  id: root
  
  anchors {
    top: true
    bottom: true
    right: true
  }
  implicitWidth: 8
  color: "transparent"
  
  // Right border - always visible, tràn viền
  Rectangle {
    id: rightBorder
    anchors {
      top: parent.top
      bottom: parent.bottom
      right: parent.right
      topMargin: 0
      bottomMargin: 0
    }
    width: 8
    color: "#5a5650"
    radius: 4
    z: 1
  }
  
  // Top corner curve connector - connects right border to top border
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
      ctx.arc(16, 16, 16, Math.PI, Math.PI * 1.5, false);
      ctx.stroke();
    }
  }
  
  // Bottom corner curve connector - connects right border to bottom border
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
      ctx.arc(16, 0, 16, Math.PI * 1.5, 0, false);
      ctx.stroke();
    }
  }
}

