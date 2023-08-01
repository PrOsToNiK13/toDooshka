import QtQuick 2.0
import QtQuick.Controls 2.4
import Qt.labs.platform

SystemTrayIcon {
    visible: true
    icon.source: "qrc:/png/icons8-plus-50.png"

    onActivated: {
        mainWindow.show()
        mainWindow.raise()
        mainWindow.requestActivate()
    }


    onMessageClicked: {
        mainWindow.show()
        mainWindow.raise()
        mainWindow.requestActivate()
    }
}
