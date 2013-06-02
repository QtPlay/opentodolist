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
    id: progressBar
    
    property int minValue: 0
    property int maxValue: 100
    property int value: 0
    property real progress: ( value - minValue ) / ( maxValue - minValue )
    
    width: 100
    height: 20
    radius: 4
    clip: true
    
    Rectangle {
        id: inner
        
        property int progress: parent.width * progressBar.progress
        
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: progress
        color: 'green'
        
        Behavior on width { SmoothedAnimation { velocity: 1200 } }
    }
    
    Text {
        anchors.centerIn: parent
        text: Math.floor( progressBar.progress * 100 ) + "%"
    }
    
}