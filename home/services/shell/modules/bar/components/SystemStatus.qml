pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property var bar

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    Component.onCompleted: SystemUsage.refCount++
    Component.onDestruction: SystemUsage.refCount--

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        CircularProgress {
            id: cpuIndicator
            width: Appearance.font.size.normal * 2.5
            height: width
            value: SystemUsage.cpuPerc
            fgColour: Colours.palette.m3primary
            strokeWidth: Appearance.padding.small * 0.8
            padding: 0
            
            property bool hovered: mouseCpu.containsMouse
            MouseArea {
                id: mouseCpu
                anchors.fill: parent
                hoverEnabled: true
            }

            MaterialIcon {
                anchors.centerIn: parent
                text: "memory"
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3primary
            }

            Tooltip {
                target: cpuIndicator
                text: `CPU: ${Math.round(SystemUsage.cpuPerc * 100)}%`
            }
        }

        CircularProgress {
            id: memIndicator
            width: Appearance.font.size.normal * 2.5
            height: width
            value: SystemUsage.memPerc
            fgColour: Colours.palette.m3secondary
            strokeWidth: Appearance.padding.small * 0.8
            padding: 0

            property bool hovered: mouseMem.containsMouse
            MouseArea {
                id: mouseMem
                anchors.fill: parent
                hoverEnabled: true
            }

            MaterialIcon {
                anchors.centerIn: parent
                text: "memory_alt"
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3secondary
            }

            Tooltip {
                target: memIndicator
                text: `RAM: ${Math.round(SystemUsage.memPerc * 100)}%`
            }
        }
    }
}
