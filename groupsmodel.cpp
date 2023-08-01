#include "groupsmodel.h"

groupsModel::groupsModel(QObject *parent) : QSqlQueryModel(parent)
{
    this->updateModel();
}

QVariant groupsModel::data(const QModelIndex & index, int role) const {

    int columnId = role - Qt::UserRole - 1;

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

int groupsModel::getId(int row)
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

int groupsModel::getSize()
{
    return size;
}

QString groupsModel::getName(int row)
{
    return this->data(this->index(row, 1), NameRole).toString();
}

QHash<int, QByteArray> groupsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "groupsId";
    roles[NameRole] = "groupsName";
    return roles;
}

void groupsModel::updateModel()
{
    QSqlQuery queryCount("SELECT COUNT(*) FROM groups");
    if (queryCount.exec() && queryCount.first()) {
        size = queryCount.value(0).toInt();
    } else {

    }
    QSqlQueryModel::setQuery("SELECT * FROM groups");
}
