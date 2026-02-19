pragma ComponentBehavior: Bound

import qs.components
import qs.components.containers
import qs.services
import qs.config
import qs.modules.bar
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData
        readonly property bool barDisabled: {
            const regexChecker = /^\^.*\$$/;
            for (const filter of Config.bar.excludedScreens) {
                // If filter is a regex
                if (regexChecker.test(filter)) {
                    if ((new RegExp(filter)).test(modelData.name))
                        return true;
                } else {
                    if (filter === modelData.name)
                        return true;
                }
            }
            return false;
        }

        Exclusions {
            screen: scope.modelData
            bar: bar
        }

        StyledWindow {
            id: win

            readonly property bool hasFullscreen: Niri.hasFullscreen
            readonly property int dragMaskPadding: {
                if (focusGrab.hasCurrent || panels.popouts.isDetached)
                    return 0;

                const hasWindows = Niri.toplevels.values.some(
                    w => w.workspaceId === Niri.focusedWorkspace?.id);
                if (hasWindows)
                    return 0;

                const thresholds = [];
                for (const panel of ["dashboard", "launcher", "session", "sidebar"])
                    if (Config[panel].enabled)
                        thresholds.push(Config[panel].dragThreshold);
                return Math.max(...thresholds);
            }

            onHasFullscreenChanged: {
                visibilities.launcher = false;
                visibilities.session = false;
                visibilities.dashboard = false;
            }

            screen: scope.modelData
            name: "drawers"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.launcher || visibilities.session ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            mask: Region {
                x: focusGrab.hasCurrent ? 0 : bar.implicitWidth
                y: focusGrab.hasCurrent ? 0 : Config.border.thickness
                width: focusGrab.hasCurrent ? win.width : (win.width - bar.implicitWidth - Config.border.thickness)
                height: focusGrab.hasCurrent ? win.height : (win.height - Config.border.thickness * 2)
                
                // When active, we want full coverage.
                // intersection: Intersection.Xor with an empty 'regions' list will result in the original rect (Xor 0 = 1).
                intersection: Intersection.Xor

                regions: focusGrab.hasCurrent ? [] : regions.instances
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x + bar.implicitWidth
                    y: modelData.y + Config.border.thickness
                    width: modelData.width
                    height: modelData.height
                    intersection: Intersection.Subtract
                }
            }

            // Niri-compatible focus grab: transparent overlay captures clicks outside panels
            QtObject {
                id: focusGrab

                // mirrors the HyprlandFocusGrab.active condition
                readonly property bool hasCurrent:
                    (visibilities.launcher && Config.launcher.enabled) ||
                    (visibilities.session  && Config.session.enabled)  ||
                    (visibilities.sidebar  && Config.sidebar.enabled)  ||
                    (!Config.dashboard.showOnHover && visibilities.dashboard && Config.dashboard.enabled) ||
                    (panels.popouts.currentName.startsWith("traymenu") && panels.popouts.current?.depth > 1)
            }

            MouseArea {
                anchors.fill: parent
                z: -1
                enabled: focusGrab.hasCurrent
                onClicked: event => {
                    // Check if click is inside any panel
                    const local = mapToItem(panels, event.x, event.y);
                    if (!panels.childAt(local.x, local.y)) {
                        visibilities.launcher = false;
                        visibilities.session  = false;
                        visibilities.sidebar  = false;
                        visibilities.dashboard = false;
                        panels.popouts.hasCurrent = false;
                        bar.closeTray();
                    }
                }
            }

            StyledRect {
                anchors.fill: parent
                opacity: visibilities.session && Config.session.enabled ? 0.5 : 0
                color: Colours.palette.m3scrim

                Behavior on opacity {
                    Anim {}
                }
            }

            Item {
                anchors.fill: parent
                opacity: Colours.transparency.enabled ? Colours.transparency.base : 1
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
                }

                Border {
                    bar: bar
                }

                Backgrounds {
                    panels: panels
                    bar: bar
                }
            }

            PersistentProperties {
                id: visibilities

                property bool bar
                property bool osd
                property bool session
                property bool launcher
                property bool dashboard
                property bool utilities
                property bool sidebar

                Component.onCompleted: Visibilities.load(scope.modelData, this)
            }

            Interactions {
                screen: scope.modelData
                popouts: panels.popouts
                visibilities: visibilities
                panels: panels
                bar: bar

                Panels {
                    id: panels

                    screen: scope.modelData
                    visibilities: visibilities
                    bar: bar
                }

                BarWrapper {
                    id: bar

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    screen: scope.modelData
                    visibilities: visibilities
                    popouts: panels.popouts

                    disabled: scope.barDisabled

                    Component.onCompleted: Visibilities.bars.set(scope.modelData, this)
                }
            }
        }
    }
}
