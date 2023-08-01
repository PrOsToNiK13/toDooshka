#ifndef DATABASE_H
#define DATABASE_H
#include <QWidget>


class database :public QObject
{
    Q_OBJECT
public:
    database();
    //основное
    Q_INVOKABLE bool connectToDataBase(QString path);
    bool openDataBase(QString path);
    bool restoreDataBase(QString path);
    bool createTables();

    Q_INVOKABLE int checkTasksByDate(QString date);

    //группы
    bool isNameAvailable(QString _name);
    QString getAvailableName(QString baseName);
    Q_INVOKABLE void insertIntoGroups(QString name);
    Q_INVOKABLE void renameGroup(QString id, QString newName);
    Q_INVOKABLE void deleteGroup(QString id);

    //задачи
    Q_INVOKABLE void insertIntoTasks(QString groupId, QString importance, QString text, QString dateTime);
    void setTaskImportant(QString id, bool important);
    Q_INVOKABLE void editTask(QString id, QString text);
    Q_INVOKABLE void changeTasksDate(QString id, QString date);
    Q_INVOKABLE void deleteTask(QString id);

};

#endif // DATABASE_H

