#ifndef TODOLIST_H
#define TODOLIST_H

#include "todoslist.h"
#include "toplevelitem.h"

#include <QObject>
#include <QQmlListProperty>


class TodoList : public TopLevelItem
{
  Q_OBJECT
  Q_PROPERTY(QQmlListProperty<Todo> todos READ todoList NOTIFY todosChanged)
public:
  
  static const QString ItemType;
  static const QStringList PersistentProperties;
  
  explicit TodoList(const QString &directory = QString(), QObject *parent = 0);
  
  Q_INVOKABLE Todo* addTodo(const QString &title);
  TodosList todos();
  QQmlListProperty<Todo> todoList();
  
  // Item interface
  void handleFileChanged(const QString &filename) override;
  
signals:
  
  /**
     @brief The list of todos changed.
   */
  void todosChanged();
  
  /**
     @brief One of the properties of the @p todo changed.
   */
  void todoChanged(Todo *todo);
  
  /**
     @brief A todo has been added to the todo list.
   */
  void todoAdded();
  
  /**
     @brief The todo ad the given @p index has been deleted.
   */
  void todoDeleted(int index);
  
public slots:
  
protected:
  // Item interface
  bool deleteItemData() override;

private:
  
  TodosList m_todos;
  bool m_todosLoaded;
  
  void appendTodo(Todo *todo);
  bool containsTodo(const QUuid &uuid);
  void loadTodos();
  void deleteDanglingTodos();
  void scanTodos();
  
  static int todoListCount(QQmlListProperty<Todo> *property);
  static Todo* todoListAt(QQmlListProperty<Todo> *property, int index);
  
private slots:
  
  void onTodoDeleted(Item *item);
  void onItemDeleted(QObject *item);
  void handleTodoChanged();
  
  
};

#endif // TODOLIST_H
