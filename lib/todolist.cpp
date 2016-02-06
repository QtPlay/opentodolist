#include "todolist.h"

#include "todo.h"

#include <QDir>


const QString TodoList::ItemTye = "TodoList";
const QStringList TodoList::PersistentProperties = {};

TodoList::TodoList(const QString &directory, QObject *parent) :
  TopLevelItem(false, directory, ItemTye, PersistentProperties, parent),
  m_todos(),
  m_todosLoaded(false)
{
  initializeItem();
}

Todo *TodoList::addTodo(const QString &title)
{
  QString todosDir = directory() + "/todos/";
  QString tpl = titleToDirectoryName(title);
  int i = 0;
  QString todoDir = todosDir + tpl;
  while (QDir(todoDir).exists()) {
    todoDir = todosDir + tpl + " - " + QString::number(i++);
  }
  Todo *todo = new Todo(todoDir, this);
  Q_CHECK_PTR(todo);
  todo->setTitle(title);
  appendTodo(todo);
  todo->saveItem(SaveItemImmediately);
  return todo;
}

TodosList TodoList::todos()
{
  loadTodos();
  return m_todos;
}

void TodoList::appendTodo(Todo *todo)
{
  Q_CHECK_PTR(todo);
  todo->setTodoList(this);
  connect(todo, &Item::itemDeleted, this, &TodoList::onTodoDeleted);
  m_todos.append(todo);
}

bool TodoList::containsTodo(const QUuid &uuid)
{
  for (auto todo : m_todos) {
    if (todo->uid() == uuid) {
      return true;
    }
  }
  return false;
}

void TodoList::loadTodos()
{
  if (!m_todosLoaded) {
    QDir todosDir(directory() + "/todos/");
    for (auto entry : todosDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
      QString todoDir = todosDir.absoluteFilePath(entry);
      if (isItemDirectory<Todo>(todoDir)) {
        Todo *todo = new Todo(todoDir, this);
        Q_CHECK_PTR(todo);
        if (containsTodo(todo->uid())) {
          delete todo;
          continue;
        }
        appendTodo(todo);
      }
    }
    m_todosLoaded = true;
  }
}

void TodoList::onTodoDeleted(Item *item)
{
  Q_CHECK_PTR(item);
  for (int i = 0; i < m_todos.size(); ++i) {
    auto todo = m_todos.at(i);
    if (todo->uid() == item->uid()) {
      todo->deleteLater();
      m_todos.removeAt(i);
      break;
    }
  }
}