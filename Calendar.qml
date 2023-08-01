import QtQuick 2.0

ListView {
    id: root

     function set(date) {
        selectedDate = new Date(date)
        positionViewAtIndex((selectedDate.getFullYear()) * 12 + selectedDate.getMonth(), ListView.Center) // index from month year
    }

    signal clicked(date date);

    property date selectedDate: new Date()

    width: 250 ;  height: 250
    snapMode:    ListView.SnapOneItem
    orientation: Qt.Horizontal
    clip:        true

    model: 50 * 12 // 50 лет по 12 месяцев - общий размер календаря

    delegate: Item {
        property int year:      Math.floor((new Date().getFullYear() * 12 + new Date().getMonth() + index)/ 12) //определяет год, отсчитывая от текущей даты
        property int month:     (new Date().getMonth() + index) % 12 // определяет месяц, прибавляя к текущему месяцу index
        property int firstDay:  new Date(year, month, 0).getDay() // от 0 до 6 в зависимости от дня недели

        width: root.width;  height: root.height

        Column {
            Item {
                width: root.width;  height: root.height - grid.height

                Text {
                    anchors.centerIn: parent
                    text: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                           'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'][month] + ' ' + year
                    font.pixelSize: 0.5 * grid.cellHeight
                }
            }

            Grid {
                id: grid

                width: root.width;  height: 0.875 * root.height
                property real cellWidth:  width  / columns;
                property real cellHeight: height / rows

                columns: 7
                rows:    7

                Repeater {
                    model: grid.columns * grid.rows // 49 клеток на каждый месяц

                    delegate: Rectangle {
                        property int day: index - 7 - firstDay + 1 // простановка каждому индексу дня, начиная с отрицательных чисел дня строки с днями недели + невходящих в месяц дней

                        color: mouseArea.containsMouse ? "lightgrey" : "white"
                        width: grid.cellWidth;  height: grid.cellHeight
                        border.width: 0.3 * radius
                        border.color: new Date(year, month, day).toDateString() == selectedDate.toDateString()  &&  text.text  &&  day >= 0?
                                      'black': 'transparent' // border выбранной даты
                        radius: 0.02 * root.height
                        opacity: !mouseArea.pressed? 1 : 0.3

                        Text {
                            id: text

                            anchors.centerIn: parent
                            font.pixelSize: 0.5 * parent.height
                            font.bold: day > 0 && new Date(year, month, day).toDateString() == new Date().toDateString() // Жирным сегодняшнее число
                            text: {
                                if(index < 7) ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'][index] // Пн-Вс
                                else if(new Date(year, month, day).getMonth() == month)  day // Проверка на наличие такой даты в месяце и вывод если существует
                                else ''
                            }
                        }

                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            enabled:    text.text  &&  day >= 0 && (new Date(year, month, day) >= new Date(new Date().getFullYear(), new Date().getMonth() , new Date().getDate()))
                            hoverEnabled: true

                            onClicked: {
                                selectedDate = new Date(year, month, day)
                                root.clicked(selectedDate)
                            }
                        }
                    }
                }
            }
        }
    }
}
