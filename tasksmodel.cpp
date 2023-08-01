#include "tasksmodel.h"


tasksModel::tasksModel(QObject *parent) : QSqlQueryModel(parent)
{
    this->updateModel(-1);
}

QVariant tasksModel::data(const QModelIndex & index, int role) const {

    int columnId = role - Qt::UserRole - 1;

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

int tasksModel::getId(int row)
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

QHash<int, QByteArray> tasksModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "tasksId";
    roles[ImportantRole] = "tasksImportance";
    roles[GroupIdRole] = "tasksGroupId";
    roles[TextRole] = "tasksText";
    roles[DateRole] = "tasksDate";
    return roles;
}

void tasksModel::updateModel(int id)
{
    QString _query = "SELECT * FROM tasks WHERE groupId = ";
    _query+= QString::number(id);

    this->setQuery(_query);
}
