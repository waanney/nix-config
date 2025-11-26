//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick

QtObject {
  id: root
  
  Component.onCompleted: {
    // Load leftbar (statusbar)
    const leftbarComponent = Qt.createComponent("panels/leftbar.qml");
    if (leftbarComponent.status === Component.Ready) {
      leftbarComponent.createObject(null);
    } else {
      console.error("Failed to load leftbar:", leftbarComponent.errorString());
    }
    
    // Load rightbar
    const rightbarComponent = Qt.createComponent("panels/rightbar.qml");
    if (rightbarComponent.status === Component.Ready) {
      rightbarComponent.createObject(null);
    } else {
      console.error("Failed to load rightbar:", rightbarComponent.errorString());
    }
    
    // Load topbar
    const topbarComponent = Qt.createComponent("panels/topbar.qml");
    if (topbarComponent.status === Component.Ready) {
      topbarComponent.createObject(null);
    } else {
      console.error("Failed to load topbar:", topbarComponent.errorString());
    }
    
    // Load bottombar
    const bottombarComponent = Qt.createComponent("panels/bottombar.qml");
    if (bottombarComponent.status === Component.Ready) {
      bottombarComponent.createObject(null);
    } else {
      console.error("Failed to load bottombar:", bottombarComponent.errorString());
    }
  }
}


