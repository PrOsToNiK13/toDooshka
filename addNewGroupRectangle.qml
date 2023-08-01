import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle{
    id:root
    height: 40
    width: parent.width
    anchors.bottom: parent.bottom
    anchors.margins: 5

    RowLayout{
        spacing: 10
        Text {
            id: plusText
            text: qsTr("+")
            font.bold: true
            font.pixelSize: 20

        }
    }
}
