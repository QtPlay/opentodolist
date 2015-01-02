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

import QtQuick 2.0

Item {
    id: autoHide

    property int maxStayVisibleTime: 1000
    property Item target: null

    function show() {
        if ( target ) {
            target.opacity = 1.0
        }
        timer.restart();
    }

    Timer {
        id: timer

        interval: maxStayVisibleTime
        repeat: false

        onTriggered: {
            if ( target ) {
                target.opacity = 0.0
            }
        }
    }
}
