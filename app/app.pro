TEMPLATE = app
TARGET = OpenTodoList

include(../config.pri)
include(../lib/lib.pri)

QT += qml quick widgets svg xml concurrent

SOURCES += main.cpp

RESOURCES += qml.qrc \
    res.qrc

config_qtsingleapplication {
    # Use system QtSingleApplication
    CONFIG += qtsingleapplication
    DEFINES += HAS_QTSINGLEAPPLICATION
} else {
    !ios&!android {
        # Use built-in QtSingleApplication
        include(../3rdparty/qtsingleapplication/src/qtsingleapplication.pri)
    }
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD

# Android: Set app name and point to Android files to be used:
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
ANDROID_PACKAGE = net.rpdev.opentodolist
ANDROID_APP_NAME = Open Todo List

# Icons for various platforms
mac:ICON = res/OpenTodoList.icns
win32:RC_FILE = OpenTodoList.rc

OTHER_FILES += \
    android/AndroidManifest.xml


target.path = $$INSTALL_PREFIX$$INSTALL_SUFFIX_BIN
INSTALLS += target
