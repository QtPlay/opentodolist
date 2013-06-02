/*
 *  OpenTodoListCore - Core functionality for the OpenTodoList application
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

#include "todosortfiltermodel.h"

#include "abstracttodo.h"

TodoSortFilterModel::TodoSortFilterModel(QObject* parent): 
    QSortFilterProxyModel(parent),
    m_filterMode( NoFilter ),
    m_parentTodo( 0 )
{
}

void TodoSortFilterModel::setSourceModel(TodoSortFilterModel::TodoModel* sourceModel)
{
    m_model = sourceModel;
    QSortFilterProxyModel::setSourceModel( sourceModel );
}

void TodoSortFilterModel::setParentTodo(AbstractTodo* todo)
{
    if ( m_filterMode == SubTodos ) {
        emit beginResetModel();
        m_parentTodo = todo;
        emit endResetModel();
    } else {
        m_parentTodo = todo;
    }
}

bool TodoSortFilterModel::filterAcceptsRow(int source_row, const QModelIndex& source_parent) const
{
    bool result = QSortFilterProxyModel::filterAcceptsRow(source_row, source_parent);
    switch ( m_filterMode ) {
        case TodoListEntries:
        {
            AbstractTodo* todo = qobject_cast< AbstractTodo* >( m_model->index( source_row, 0 ).data( TodoModel::ObjectRole ).value< QObject* >() );
            return ( todo && !todo->parentTodo() ) ? result : false;
        }
        
        case SubTodos:
        {
            AbstractTodo* todo = qobject_cast< AbstractTodo* >( m_model->index( source_row, 0 ).data( TodoModel::ObjectRole ).value< QObject* >() );
            return ( todo && todo->parentTodo() == m_parentTodo ) ? result : false;
        }
        
        default:
            return result;
    }
}
