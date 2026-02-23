pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.components
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

StyledClippingRect {
    id: root

    required property ShellScreen screen

    readonly property var focusedWorkspace: Niri.focusedWorkspace
    readonly property var wsValues: (Niri.workspaces.values ?? []).filter(w => w.name != null && w.name !== "")

    implicitWidth: Config.bar.sizes.innerWidth
    implicitHeight: layout.implicitHeight + Appearance.padding.small * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.full

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Math.floor(Appearance.spacing.small / 2)

        Repeater {
            id: workspaces

            model: ScriptModel {
                values: root.wsValues
            }

            Workspace {
                required property var modelData

                workspace: modelData
                focusedWorkspace: root.focusedWorkspace
            }
        }
    }

    Loader {
        anchors.horizontalCenter: parent.horizontalCenter
        active: Config.bar.workspaces.activeIndicator && workspaces.count > 0

        sourceComponent: ActiveIndicator {
            focusedWorkspace: root.focusedWorkspace
            workspaces: workspaces
            mask: layout
        }
    }

    MouseArea {
        anchors.fill: layout
        onClicked: event => {
            const item = layout.childAt(event.x, event.y);
            const ws = item?.workspace;
            if (!ws) return;
            const wsName = ws.name ?? ws.id.toString();
            if (Niri.focusedWorkspace?.id !== ws.id)
                Niri.focusWorkspace(wsName);
        }
    }
}
