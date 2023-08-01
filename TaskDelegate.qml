import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0

Rectangle {
    id: root

    height: 74
    radius: 10

    color: tasksMenu.visible ? "#ffffff" : "#eeeff3"
    width: scrollBar.visible ? taskListView.width - (scrollBar.width+3)  : taskListView.width

    RowLayout{
        anchors.fill:  parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing:  10

        ColumnLayout{
            Layout.fillWidth: true

            TextField {
                id: tText

                readOnly : true
                text: tasksText
                font.pixelSize: 18
                Layout.fillWidth: true;
                Layout.topMargin: 5

                background: Rectangle{
                    color: tText.readOnly ?  root.color : "lightGrey"
                    radius: 8
                }

                onEditingFinished: {
                    focus = false
                }

                onFocusChanged: {
                    if(!focus && !readOnly){
                        readOnly = true
                        db.editTask(tModel.getId(index), text)
                        tModel.updateModel(grModel.getId(groupsListView.currentIndex))
                    }
                }
            }
            Text{
                id: time
                Layout.fillWidth: true;
                Layout.leftMargin: 8
                Layout.bottomMargin: 5
                text: tasksDate === Qt.formatDate(new Date()) ?"Сегодня" : tasksDate
                color: text == "Сегодня" ? "red" : "black"
                visible: tasksDate == "" ? false : true
            }
        }

        Button{
            id: button_openMenu

            background: Rectangle{
                anchors.fill: parent
                radius: 4
                border.width: 1

            }

            Layout.preferredHeight: 20
            Layout.preferredWidth: 40

            text: "..."
            font.pixelSize: 16

            onClicked: {
                tasksMenu.y = parent.y + 74
                tasksMenu.x = parent.x + parent.width - tasksMenu.width
                tasksMenu.visible = true
            }
        }
    }

    Menu {
        id: tasksMenu
        width: 400
        font.pixelSize: 24

        MenuItem {
            text: "Редактировать"
            onTriggered: {
                tText.readOnly = false
                tText.selectAll()
                tText.forceActiveFocus()
            }
        }
        MenuItem {
            text: "Удалить"
            onTriggered: {
                db.deleteTask(tModel.getId(index))
                tModel.updateModel(grModel.getId(groupsListView.currentIndex))
            }
        }

        MenuItem {
            id: addDate
            text: "Установить дату"
            onTriggered: {
                dPicker.delegatesIndex = index
                var tempY =  taskDelegate.mapToItem(tasksWidget, 0, 0).y + taskDelegate.height;
                dPicker.x = taskListView.x + taskDelegate.width - (dPicker.width + 50);
                dPicker.y = tempY + dPicker.height < taskListView.y + taskListView.height ?  tempY : taskListView.y + taskListView.height - dPicker.height;
                dPicker.visible = true
                dPicker.forceActiveFocus()

//                Qt.createQmlObject("DataPicker{
//                                        property var tempY: taskDelegate.mapToItem(tasksWidget, 0, 0).y + taskDelegate.height;
//                                        x: taskListView.x + taskDelegate.width - (width+ 50);
//                                        y: tempY + height < taskListView.y + taskListView.height ?  tempY : taskListView.y + taskListView.height - height;}",
//                                   tasksWidget)
            }
        }

        MenuItem {
            id: removeDate
            text: "Очистить дату"
            onTriggered: {
                db.changeTasksDate(tModel.getId(index), "")
                tModel.updateModel(grModel.getId(groupsListView.currentIndex))
            }
        }
    }

}
