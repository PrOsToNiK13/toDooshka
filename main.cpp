#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <database.h>
#include <tasksmodel.h>
#include <groupsmodel.h>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    database *dataBase = new database();
    dataBase->connectToDataBase(QCoreApplication::applicationDirPath() + "/database.db");
    engine.rootContext()->setContextProperty("db", dataBase);

    tasksModel *tModel = new tasksModel();
    engine.rootContext()->setContextProperty("tModel", tModel);

    groupsModel *grModel = new groupsModel();
    engine.rootContext()->setContextProperty("grModel", grModel);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);


    return app.exec();


}
