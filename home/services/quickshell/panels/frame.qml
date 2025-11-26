import Quickshell
import Quickshell.Widgets
import QtQuick

PanelWindow {
  id: root
  
  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }
  color: "transparent"
  
  // Set exclusive zone to 0 so it doesn't block mouse events
  exclusiveZone: 0
  
  // Outer frame border - wraps entire screen
  // Using only border, no fill, so it doesn't block interactions
  // No MouseArea - transparent Rectangle doesn't block events
  Rectangle {
    anchors {
      fill: parent
      margins: 8
    }
    color: "transparent"
    border.color: "#5a5650"
    border.width: 2
    radius: 16
  }
}

