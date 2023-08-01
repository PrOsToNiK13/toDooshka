#include "database.h"
#include <QtSql>
#include <QDate>

database::database()
{

}

bool database::connectToDataBase(QString path)
{
       if(!QFile(path).exists()){
           return restoreDataBase(path);
       } else {
           return openDataBase(path);
       }
}

bool database::openDataBase(QString path)
{
    QSqlDatabase sdb = QSqlDatabase::addDatabase("QSQLITE");
    sdb.setDatabaseName(path);
    if(sdb.open()){
         return true;
    } else {
        return false;
    }
}

bool database::restoreDataBase(QString path)
{
    if(openDataBase(path)){
        return (createTables() ? true : false);
    } else {
        qDebug() << "Не удалось восстановить базу данных";
        return false;
    }
    return false;
}

bool database::createTables()
{
    QSqlQuery query;
    bool isOK = true;
    if(!query.exec( "CREATE TABLE groups("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                    "name VARCHAR(50));")){
        isOK = false;
        qDebug() << "groups created";
    }
    if(!query.exec( "CREATE TABLE tasks("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                    "important INTEGER,"
                    "groupId INTEGER,"
                    "text VARCHAR(200),"
                    "date DATE);")){
        isOK = false;
        qDebug() << "tasks created";
    }
    if (isOK){
        qDebug() << "Таблицы созданы!";
        return true;
    } else {
        qDebug() << "DataBase: ошибка создания таблиц";
        return false;
    }
    return false;
}

int database::checkTasksByDate(QString date)
{
    QSqlQuery query;
    query.prepare("SELECT COUNT (*) FROM tasks WHERE dateTime = :dt");
    query.bindValue(":dt" , date);
    query.exec(); query.first();
    return query.value(0).toInt();
}



bool database::isNameAvailable(QString name) {
    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM groups WHERE name = :name");
    query.bindValue(":name", name);
    if (!query.exec()) {
        qDebug() << "Ошибка выполнения запроса!";
        return false;
    }
    query.next();
    int count = query.value(0).toInt();
    return count == 0;
}

QString database::getAvailableName(QString baseName) {

    QString name = baseName;
    int count = 1;

    while (!isNameAvailable(name)) {
        name = baseName + " (" + QString::number(count) + ")";
        count++;
    }

    return name;
}


void database::insertIntoGroups(QString name)
{
    QString _name = getAvailableName(name);

    QSqlQuery query;
    query.prepare("INSERT INTO groups (name)"
                  "VALUES (:name);");
    query.bindValue(":name", _name);
    if (!query.exec()){
        qDebug() << "Ошибка записи в таблицу groups!";
    }
}

void database::renameGroup(QString id, QString newName)
{
    QSqlQuery query;
    query.prepare("SELECT name FROM groups WHERE id = :id");
    query.bindValue(":id", id);
    query.exec(); query.next();

    if(query.value(0) != newName){
        QString validName = getAvailableName(newName);
        query.prepare("UPDATE groups SET name = :name WHERE id = :id");
        query.bindValue(":name", validName);
        query.bindValue(":id", id);
        if (!query.exec()){
            qDebug() << "Ошибка изменения имени группы!";
        }
    }
}

void database::deleteGroup(QString id)
{
    QSqlQuery query;
    query.prepare("DELETE FROM tasks WHERE groupId = :id;");
    query.bindValue(":id", id);
    if(!query.exec()){
        qDebug() << "Ошибка удаления из таблицы tasks";
    }

    query.prepare("DELETE FROM groups WHERE id = :id;");
    query.bindValue(":id", id);
    if(!query.exec()){
        qDebug() << "Ошибка удаления из таблицы groups";
    }
}





void database::insertIntoTasks(QString groupId, QString importance, QString text, QString dateTime)
{
    QSqlQuery query;
    query.prepare("INSERT INTO tasks (groupId, important, text, dateTime)"
                  "VALUES (:groupId, :importance, :text, :dateTime);");
    query.bindValue(":groupId", groupId);
    query.bindValue(":importance", importance);
    query.bindValue(":text", text);
    query.bindValue(":dateTime", dateTime);
    if (!query.exec()){
        qDebug() << "Ошибка записи в таблицу tasks!";
    }
}

void database::setTaskImportant(QString id, bool important)
{
    QSqlQuery query;
    query.prepare("UPDATE tasks SET important = :important WHERE id = :id");
    query.bindValue(":important", important);
    query.bindValue(":id", id);
    if (!query.exec()){
        qDebug() << "Ошибка изменения параметра важности задачи!";
    }
}

void database::deleteTask(QString id)
{
    QSqlQuery query;
    query.prepare("DELETE FROM tasks WHERE id = :id;");
    query.bindValue(":id", id);
    if(!query.exec()){
        qDebug() << "Ошибка удаления из таблицы tasks";
    }
}

void database::editTask(QString id, QString text)
{
    QSqlQuery query;
    query.prepare("UPDATE tasks SET text = :text WHERE id = :id");
    query.bindValue(":text", text);
    query.bindValue(":id", id);
    if (!query.exec()){
        qDebug() << "Ошибка изменения текста задачи!";
    }
}

void database::changeTasksDate(QString id, QString date)
{
    QSqlQuery query;
    query.prepare("UPDATE tasks SET dateTime = :date WHERE id = :id");
    query.bindValue(":date", date);
    query.bindValue(":id", id);
    if (!query.exec()){
        qDebug() << "Ошибка изменения группы задачи!";
    }
}

//void database::changeTasksGroup(QString id, QString groupId)
//{
//    QSqlQuery query;
//    query.prepare("UPDATE tasks SET groupId = :groupId WHERE id = :id");
//    query.bindValue(":groupId", groupId);
//    query.bindValue(":id", id);
//    if (!query.exec()){
//        qDebug() << "Ошибка изменения группы задачи!";
//    }
//}


