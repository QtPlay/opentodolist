// checksum 0x440d version 0x90003
/*
  This file was generated by the Qt Quick 2 Application wizard of Qt Creator.
  QtQuick2ApplicationViewer is a convenience class containing mobile device specific
  code such as screen orientation handling. Also QML paths and debugging are
  handled here.
  It is recommended not to modify this file, since newer versions of Qt Creator
  may offer an updated version of it.
*/

#include "qtquick2applicationviewer.h"

#include <QtCore/QCoreApplication>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>

class QtQuick2ApplicationViewerPrivate
{
    QString mainQmlFile;
    friend class QtQuick2ApplicationViewer;
};

QtQuick2ApplicationViewer::QtQuick2ApplicationViewer(QObject *parent)
    : QQmlApplicationEngine(parent)
    , d(new QtQuick2ApplicationViewerPrivate())
{
}

QtQuick2ApplicationViewer::~QtQuick2ApplicationViewer()
{
    delete d;
}

void QtQuick2ApplicationViewer::setMainQmlFile(const QString &file)
{
    d->mainQmlFile = file;
    load( d->mainQmlFile );
}