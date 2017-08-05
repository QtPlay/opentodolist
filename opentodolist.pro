TEMPLATE = subdirs
CONFIG += ordered

qrc.depends =
qrc.commands = perl $$PWD/bin/mk-qrc.pl \
               --dir $$PWD/OpenTodoList/qml/ \
               --base $$PWD/OpenTodoList/ \
               --out $$PWD/OpenTodoList/OpenTodoList.qrc
QMAKE_EXTRA_TARGETS += qrc

OTHER_FILES += \
    README.md \
    COPYING \
    Doxyfile \
    doc/installers-howto.md \
    .gitlab-ci.yml \
    .qmake.conf \
    bin/linux-deploy-qt.pl \
    bin/mk-installer.pl \
    bin/mk-pri.pl \
    bin/mk-qrc.pl \
    bin/mk-unittest.py \
    bin/mk-linux-installer-x86_64.sh \
    templates/installer/config/config.xml \
    templates/installer/config/controller.js \
    templates/installer/packages/net.rpdev.OpenTodoList/meta/script.js \
    templates/installer/packages/net.rpdev.OpenTodoList/meta/package.xml \
    $$files(ci/docker/fedora/*) \
    $$files(ci/docker/fedora_system/*) \
    $$files(ci/docker/win32/*) \
    $$files(ci/docker/win64/*) \
    $$files(ci/docker/nextcloud/*) \
    $$files(config.tests/qtsingleapplication/*) \
    $$files(config.tests/qtkeychain/*) \
    $$files(config.tests/libsecret/*) \


SUBDIRS += \
    lib \
    app \
    test

include(config.pri)
# include(installer.pri)

# Check environment for optional packages:
load(configure)

qtCompileTest(qtsingleapplication) ## check for system QtSingleApplication
config_qtsingleapplication:QT_SINGLE_APPLICATION_MODE = "System"
else:QT_SINGLE_APPLICATION_MODE = "Built-in"

qtCompileTest(qtkeychain) ## Check for QtKeychain
config_qtkeychain {
    QT_KEYCHAIN_MODE = "System"
    LIBSECRET_MODE = "System"
} else {
    QT_KEYCHAIN_MODE = "Built-in"
    qtCompileTest(libsecret) ## Check for libsecret
    config_libsecret:LIBSECRET_MODE = "Found"
    else:LIBSECRET_MODE = "Not Found"
}


message("Configure summary:")
message("    Install Prefix:         $$INSTALL_ROOT")
message("    Binary Install Prefix:  $$INSTALL_PREFIX$$INSTALL_SUFFIX_BIN")
message("    Library Install Prefix: $$INSTALL_PREFIX$$INSTALL_SUFFIX_LIB")
message("    QtSingleApplication:    $$QT_SINGLE_APPLICATION_MODE")
message("    QtKeychain:             $$QT_KEYCHAIN_MODE")
message("    Libsecret:              $$LIBSECRET_MODE")
