/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2014  Martin Höher <martin@rpdev.net>
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

#include "datamodel/datamodelplugin.h"

#include "datamodel/todo.h"
#include "datamodel/todolist.h"
#include "datamodel/todolistlibrary.h"

#include <qqml.h>
#include <QJSEngine>

namespace OpenTodoList {

namespace DataModel {

Plugin::Plugin(QObject *parent) :
    QQmlExtensionPlugin(parent)
{
}

void Plugin::registerTypes(const char *uri)
{
    //@uri net.rpdev.OpenTodoList.DataModel
    qmlRegisterType< Todo >(
                uri, 1, 0, "Todo" );
    qmlRegisterType< TodoList >(
                uri, 1, 0, "TodoList" );
    qmlRegisterType< TodoListLibrary >(
                uri, 1, 0, "TodoListLibrary" );
}

} /* DataModel */

} /* OpenTodoList */
