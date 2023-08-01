import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12

Rectangle{
    id: root

    color: "lightgrey"

    signal addNewTask(string tasksText)

    RowLayout{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"lightgrey"
            border.color: "black"
            radius: 10

            TextField {
                id: newTasksText
                anchors.fill: parent
                font.pixelSize: 14
                placeholderText: "Введите тест задачи"
                background: Rectangle {
                    color:"lightgrey"
                }

                color:  "black"
                anchors.margins: 5

                onAccepted: {
                    root.addNewTask(text)
                    clear()
                }

                onTextChanged: {
                    if(text == " "){
                        text = ""
                    }
                }
            }
        }


        Button{
            id: addNewtaskButton

            text: ">"
            font.pixelSize: 24
            Layout.minimumHeight: 40
            Layout.minimumWidth: 60

            background: Rectangle{
                color:"lightblue"
                border.color: "black"
            }

            onClicked: {
                if(newTasksText.text != ""){
                    root.addNewTask(newTasksText.text)
                    newTasksText.clear()
                }
            }
        }
    }
}
