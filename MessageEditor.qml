import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12

Rectangle{
    id: root
    height: 60
    color: "lightgrey"

    signal newMsg(string msg)


    RowLayout{
        anchors.fill: parent
        anchors.margins: defMargin
        spacing: 20
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"lightgrey"
            border.color: "black"
            radius: 10

            TextField {
                id:txtField
                anchors.fill: parent
                placeholderText: "Введите сообщение"
                background: Rectangle {
                    color:"lightgrey"
                }

                color:  "black"
                anchors.margins: 5
                focus:true
            }
        }

        Button{
            Layout.minimumHeight: 40
            Layout.minimumWidth: 60
            id: bttn
            background: Rectangle{
                color:"lightblue"
                border.color: "black"
            }

            Text{
                anchors.centerIn: parent
                font.pixelSize: 24
                text: ">"
            }

            onClicked: {
                newMsg(txtField.text)
                txtField.clear()
            }
        }
    }
}
