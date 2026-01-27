import QtQuick
import QtQuick.Layouts

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
