/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2014 - 2015 Martin Höher <martin@rpdev.net>
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

#include "disposetodo.h"

namespace OpenTodoList {
namespace DataBase {
namespace Queries {

DisposeTodo::DisposeTodo(Todo *todo) :
  DisposeObject<Todo>( todo )
{
  connect( this, &DisposeTodo::queryFinished,
           [this,todo] {
    todo->setDisposed( true );
    emit this->todoChanged( todo->toVariant() );
  });
}

DisposeTodo::~DisposeTodo()
{

}

} // namespace Queries
} // namespace DataBase
} // namespace OpenTodoList

