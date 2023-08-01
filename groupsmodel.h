#ifndef GROUPSMODEL_H
#define GROUPSMODEL_H
#include <QtSql>

class groupsModel : public QSqlQueryModel
{
    Q_OBJECT
public:

    explicit groupsModel(QObject* parent = 0);

    enum Roles {
        IdRole = Qt::UserRole + 1,      // id
        NameRole,                       // имя группы
    };

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;


public slots:
    void updateModel();
    int getId(int row);
    int getSize();
    QString getName(int row);
private:
    int size = 0;
};

#endif // GROUPSMODEL_H
