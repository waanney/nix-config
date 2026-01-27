//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import QtQuick

// Minimal shell for testing - bypasses Caelestia dependencies
ShellRoot {
    PanelWindow {
        id: testPanel
        anchors {
            top: true
            left: true
            right: true
        }
        height: 32
        exclusiveZone: height
        
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            
            Text {
                anchors.centerIn: parent
                text: "Quickshell Test - " + Qt.formatDateTime(new Date(), "hh:mm:ss")
                color: "#cdd6f4"
                font.pixelSize: 14
            }
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: testPanel.update()
        }
    }
}
