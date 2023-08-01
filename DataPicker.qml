import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item{
    id: root

    signal dateSet()

    property alias buttonSave : buttonSave
    property var selectedDate : calendar.selectedDate

    height: 306; width:  260;

    Rectangle{
        anchors.fill: parent
        border.width: 2
        border.color: "black"
        radius: 4

        Column{
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5


            Calendar{
                id: calendar

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5

                Component.onCompleted: set(new Date())
            }

            RowLayout{
                width: parent.width
                height: 40

                Button{
                    id: buttonCancel
                    Layout.leftMargin: 5
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 36
                    text: "Отмена"

                    onClicked: {
                        root.visible = false
                    }
                }

                Button{
                    id: buttonSave

                    background: Rectangle{
                        radius: 5
                        anchors.fill: parent
                        color: "red"
                    }

                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 5
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 36
                    text: "Сохранить"

                    onClicked:{
                        root.dateSet()
                    }
                }
            }
        }
    }
}
