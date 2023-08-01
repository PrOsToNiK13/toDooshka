#ifndef TASKSMODEL_H
#define TASKSMODEL_H
#include <QtSql>

class tasksModel : public QSqlQueryModel
{
    Q_OBJECT
public:

    explicit tasksModel(QObject* parent = 0);

    enum Roles {
        IdRole = Qt::UserRole + 1,      // id
        ImportantRole,                 // важная/нет
        GroupIdRole,                   //id группы
        TextRole,                      // текст
        DateRole                       // дата
    };

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;


public slots:
    void updateModel(int id);
    int getId(int row);
};

#endif // TASKSMODEL_H
