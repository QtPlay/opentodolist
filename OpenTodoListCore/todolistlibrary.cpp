/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2013  Martin Höher <martin@rpdev.net>
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "todolistlibrary.h"

#include "todo.h"
#include "todolist.h"
#include "todolistfactory.h"

#include <QCoreApplication>
#include <QDebug>
#include <QSettings>

TodoListLibrary::TodoListLibrary(QObject *parent) :
    QObject(parent),
    m_plugins( new PluginsLoader( this ) ),
    m_backendRunner( new BackendRunner( this, this ) ),
    m_lists( new TodoLists( this ) ),
    m_storage( new TodoListStorage( this ) ),
    m_todos( new TodoList::TodosList( this ) )
{
    // register basic types for thread communication
    qRegisterMetaType< TodoListStruct >( "TodoListStruct" );
    qRegisterMetaType< TodoStruct >( "TodoStruct" );

    restoreSettings();
    connect( QCoreApplication::instance(), SIGNAL(aboutToQuit()), this, SLOT(saveSettings()) );

    // start backends
    m_backendRunner->start();
}

TodoListLibrary::~TodoListLibrary()
{
    // stop backends
    m_backendRunner->stop();
}

PluginsLoader *TodoListLibrary::plugins() const
{
    return m_plugins;
}

TodoListLibrary::TodoLists* TodoListLibrary::todoLists() const
{
    return m_lists;
}

TodoList::TodosList *TodoListLibrary::todos() const
{
    return m_todos;
}

bool TodoListLibrary::createTodoList(const QString& name, OpenTodoListBackend* type)
{
    if ( !name.isEmpty() && type ) {
        TodoList* list = type->factory()->createTodoList( this );
        list->setName( name );
        m_lists->append( list );
        m_todos->appendList( list->todos() );
        return true;
    }
    return false;
}

bool TodoListLibrary::insertTodoList(const BackendInterface* backend,
                                     const TodoListStruct &list)
{
    return m_storage->insertTodoList(backend->id(), list );
}

bool TodoListLibrary::insertTodo(const BackendInterface *backend,
                                 const TodoStruct &todo)
{
    return m_storage->insertTodo( backend->id(), todo );
}

bool TodoListLibrary::deleteTodoList(const BackendInterface *backend,
                                     const TodoListStruct &list)
{
    return m_storage->deleteTodoList( backend->id(), list );
}

bool TodoListLibrary::deleteTodo(const BackendInterface *backend,
                                 const TodoStruct &todo)
{
    return m_storage->deleteTodo( backend->id(), todo );
}

OpenTodoListBackend* TodoListLibrary::backendByTypeName(const QString& type)
{
    foreach ( OpenTodoListBackend* backend, m_plugins->backends()->data() ) {
        if ( backend->type() == type ) {
            return backend;
        }
    }
    return 0;
}

void TodoListLibrary::saveSettings()
{
    /*
#ifdef Q_OS_ANDROID
    QSettings settings( TodoListFactory::androidExtStorageLocation() +
               "/config.ini", QSettings::IniFormat );
#else
    QSettings settings;
#endif
    settings.sync();
    */
}

void TodoListLibrary::restoreSettings()
{
    /*
#ifdef Q_OS_ANDROID
    QSettings settings( TodoListFactory::androidExtStorageLocation() +
               "/config.ini", QSettings::IniFormat );
#else
    QSettings settings;
#endif
    */
}
