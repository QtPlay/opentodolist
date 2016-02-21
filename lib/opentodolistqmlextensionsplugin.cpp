#include "opentodolistqmlextensionsplugin.h"

#include "application.h"
#include "complexitem.h"
#include "documentformatter.h"
#include "image.h"
#include "item.h"
#include "libraryfactory.h"
#include "library.h"
#include "note.h"
#include "task.h"
#include "todo.h"
#include "todolist.h"
#include "toplevelitem.h"


#include <QtQml>

OpenTodoListQmlExtensionsPlugin::OpenTodoListQmlExtensionsPlugin(QObject *parent) : 
  QQmlExtensionPlugin(parent)
{
  
}

void OpenTodoListQmlExtensionsPlugin::registerTypes(const char *uri)
{
  //@uri net.rpdev.OpenTodoList
  
  qmlRegisterSingletonType<Application>(uri, 1, 0, "App",
                                        OpenTodoListQmlExtensionsPlugin::createApplication);
  qmlRegisterType<ComplexItem>(uri, 1, 0, "ComplexItem");
  qmlRegisterType<Image>(uri, 1, 0, "ImageItem");
  qmlRegisterType<Item>(uri, 1, 0, "BasicItem");
  qmlRegisterType<DocumentFormatter>(uri, 1, 0, "DocumentFormatter");
  qmlRegisterUncreatableType<Library>(uri, 1, 0, "Library",
                                      "Must be created using Application.");
  qmlRegisterUncreatableType<LibraryFactory>(uri, 1, 0, "LibraryFactory", 
                                             "Cannot create LibraryFactory in QML.");
  qmlRegisterType<Note>(uri, 1, 0, "Note");
  qmlRegisterType<Task>(uri, 1, 0, "Task");
  qmlRegisterType<Todo>(uri, 1, 0, "Todo");
  qmlRegisterType<TodoList>(uri, 1, 0, "TodoList");
  qmlRegisterType<TopLevelItem>(uri, 1, 0, "TopLevelItem");
}

QObject *OpenTodoListQmlExtensionsPlugin::createApplication(QQmlEngine *engine, QJSEngine *jsEngine)
{
  Q_UNUSED(engine);
  Q_UNUSED(jsEngine);
  return new Application();
}