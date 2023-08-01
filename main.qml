import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs

ApplicationWindow {
    id:mainWindow
    visible: true
    minimumHeight: 720
    minimumWidth: 1280
    readonly property int defMargin: 10
    property int lastSelectedIndex: -1

    SysTrayIcon{
        id: sysTray
    }

    Timer{
        id: tasksChecker
        interval: 14400000
        triggeredOnStart: true
        repeat: true

        Component.onCompleted: {
            tasksChecker.triggered()
            tasksChecker.start()
        }

        onTriggered:{
            var taskscount = db.checkTasksByDate(Qt.formatDate(new Date()));
            if(taskscount > 0){
                sysTray.showMessage("Сегодня есть невыполненные задачи!", "\n\n Проверьте приложение за дополнительной информацией");
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle{
            id:groupWidget

            color: "#d1d1d1"
            width: 280
            Layout.fillHeight: true
            border.color: "black"

            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 5
                spacing: 10
                Rectangle{
                    id:rect1
                    width: parent.width
                    height: groupsTitle.implicitHeight + 10
                    Text{
                        id:groupsTitle
                        text: "Группы"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 18
                        font.underline: true
                    }
                    border.color: "black"
                }

                Item{
                    id:groupslistViewItem
                    Layout.fillHeight: true
                    width: parent.width

                    property bool isMenuOpen: false

                    ListView{
                        id:groupsListView

                        property color defalutColor: "#d1d1d1"
                        Component.onCompleted: {
                           tasksWidget.updateTasks(grModel.getName(groupsListView.currentIndex), groupsListView.currentIndex)
                        }
                        anchors.fill: parent

                        highlightMoveDuration: 0
                        highlight: Rectangle {
                            border.color: "blue"
                            border.width: 6
                        }

                        clip: true
                        spacing: 5
                        ScrollBar.vertical: ScrollBar{}
                        model: grModel

                        delegate: Rectangle {
                            id:groupsDelegate

                            color: ListView.isCurrentItem ? Qt.darker(groupsListView.defalutColor, 1.1) : groupsListView.defalutColor
                            height: 40
                            x: 3
                            width: ListView.view.width
                            anchors.margins: 5

                            function setEditingSettings(){
                                groupName.isEditable = true
                                groupName.selectAll()
                                groupName.forceActiveFocus()
                            }

                            TextField {
                                id: groupName

                                property bool isEditable : false

                                readOnly: false
                                selectByMouse: true
                                anchors.fill:  parent
                                anchors.margins: 8

                                background: Rectangle{
                                    color: groupName.isEditable ?  "white" : groupsDelegate.color
                                    radius: 8
                                }

                                text: groupsName
                                font.bold: true
                                font.pixelSize: 14

                                onEditingFinished: {
                                    focus = false
                                }

                                onActiveFocusChanged: {
                                    if(!activeFocus && isEditable){
                                        isEditable = false
                                        db.renameGroup(grModel.getId(index), text)
                                        tasksWidget.updateTasks(text, index)
                                        grModel.updateModel();
                                    }

                                }
                            }

                            Menu {
                                id: groupMenu
                                //width: 110

                                MenuItem {
                                    text: "Удалить"
                                    onTriggered: {
                                        groupsListView.currentIndex = -1
                                        db.deleteGroup(grModel.getId(index))
                                        grModel.updateModel()
                                    }
                                }

                                MenuItem {
                                    text: "Редактировать"
                                    onTriggered: {
                                        groupsDelegate.setEditingSettings()
                                    }
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                onClicked: (mouse)=> {
                                    if (mouse.button === Qt.RightButton) {
                                        var mousePos = mapToItem(parent, mouse.x, mouse.y)
                                        groupMenu.y = mousePos.y
                                        groupMenu.forceActiveFocus()
                                        groupMenu.x = mousePos.x
                                        groupMenu.visible = true
                                    } else if (mouse.button === Qt.LeftButton) {
                                        groupsListView.currentIndex = index
                                    }
                                }
                            }
                        }

                        onCurrentIndexChanged: {
                            tasksWidget.forceActiveFocus()
                            tasksWidget.updateTasks(grModel.getName(currentIndex), currentIndex)
                        }
                    }
                }

                AddNewGroupWidget{
                    id:addNewGroupWidget
                    color:groupWidget.color

                    onClicked: {
                        forceActiveFocus()

                        if (groupsListView.currentIndex >= 0) {
                            var currentDelegate = groupsListView.itemAtIndex(groupsListView.currentIndex);
                            if(!currentDelegate.children[0].readOnly){
                                currentDelegate.children[0].onEditingFinished()
                            }
                        }

                        db.insertIntoGroups("Безымянная группа ")
                        grModel.updateModel()

                        groupsListView.currentIndex = grModel.getSize() - 1
                        var delegate = groupsListView.itemAtIndex(grModel.getSize() - 1); // Получение делегата по индексу
                        delegate.setEditingSettings()
                    }
                }
            }
        }

        Rectangle{
            id: tasksWidget

            color: "#7488da"
            Layout.fillWidth: true;
            Layout.fillHeight: true;

            function updateTasks(text, index){
                if(groupsListView.currentIndex === index){
                    tasksGroupName.text = text
                    tModel.updateModel(grModel.getId(index))
                }
            }

            DataPicker{
                id: dPicker
                visible: false
                z: 1

                property int delegatesIndex: 0

                onDateSet: {
                    db.changeTasksDate(tModel.getId(delegatesIndex), Qt.formatDate(dPicker.selectedDate))
                    tModel.updateModel(grModel.getId(groupsListView.currentIndex))
                    dPicker.visible = false
                }

                onActiveFocusChanged: {
                    if(!activeFocus && !buttonSave.activeFocus){
                        dPicker.visible = false
                    }
                }
            }


            ColumnLayout{
                anchors.fill: parent
                spacing: -8

                Text{
                    id: tasksGroupName
                    Layout.alignment: Qt.AlignHCenter
                    height: 36
                    font.pixelSize: 24
                    text: ""
                    Layout.margins: 6
                }

                ListView{
                    id:taskListView

                    spacing: defMargin
                    clip: true
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 10

                    ScrollBar.vertical: ScrollBar{
                        id: scrollBar

                        onPositionChanged: {
                            forceActiveFocus()
                        }
                    }

                    model: tModel

                    delegate: TaskDelegate{
                        id: taskDelegate

                    }
                }

                TaskEditor{
                    Layout.fillWidth: true;
                    Layout.maximumHeight: 60
                    height: 60
                    onAddNewTask: {
                        db.insertIntoTasks(grModel.getId(groupsListView.currentIndex), 0, tasksText, "")
                        tModel.updateModel(grModel.getId(groupsListView.currentIndex))
                    }
                }

            }
       }
    }
}






