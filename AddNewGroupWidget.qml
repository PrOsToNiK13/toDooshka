import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2

Rectangle{
    id:root
    height: 46
    width: parent.width
    anchors.margins: 0

    signal clicked()

    RowLayout{
        anchors.fill: parent
        spacing: 10
        Image {
            Layout.margins: 0
            id: plusText
            scale: 0.6
            Layout.topMargin: 0
            source:"qrc:/png/icons8-plus-50.png"
        }

        Text {
            Layout.alignment: Qt.AlignLeft
            id: addNewGroupText
            text: "Новая группа"
            font.pixelSize:16
        }


        Item {
            Layout.fillWidth: true
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            root.color = Qt.darker(root.color, 1.08)
        }
        onExited: {
            root.color = "#d1d1d1"
        }
        onClicked: {
            root.clicked()
        }
    }
}
