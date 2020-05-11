#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include "candrv.h"
#include "displaydrv.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    qDebug() << "1";

    qmlRegisterType<CanDrv>("CanDrv", 1, 0, "CanDrv");
    qmlRegisterType<DisplayDrv>("DisplayDrv", 1, 0, "DisplayDrv");

    qDebug() << "2";

    QQmlApplicationEngine engine;
//    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
//    if (engine.rootObjects().isEmpty())
//        return -1;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    qDebug() << "3";
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    qDebug() << "4";
    engine.load(url);

    qDebug() << "5";

    return app.exec();
}
