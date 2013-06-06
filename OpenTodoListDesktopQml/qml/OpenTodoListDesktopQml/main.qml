/*
 *  OpenTodoListDesktopQml - Desktop QML frontend for OpenTodoList
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

import QtQuick 2.0

Rectangle {
    id: root
    width: 800
    height: 600
    color: activePalette.window
    
    /*
     * Not working, see https://bugreports.qt-project.org/browse/QTBUG-26317
     *    SystemPalette { 
     *        id: activePalette
     }
     */
    // Workaround:
    Item {
        id: activePalette
        property color window: "#eeeeee"
        property color button: "#dddddd"
        property color buttonText: "#000000"
    }
    
    TodoListView {
        id: todoListView
        
        onTodoSelected: todoDetailsView.todo = todo
    }
    
    NewTodoListView {
        id: newTodoListView
    }
       
    TodoDetailsView {
        id: todoDetailsView
    }
    
    
}
             