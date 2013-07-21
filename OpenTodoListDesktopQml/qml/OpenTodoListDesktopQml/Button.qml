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
    id: button

    property alias label: label.text
    property alias pressed: mouseArea.pressed
    property alias containsMouse: mouseArea.containsMouse
    property alias font: label.font
    property color backgroundColor: colors.primary
    property color highlightColor: colors.primaryLighter1
    property bool down: false
    
    signal clicked

    height: label.height + 10
    width: label.width + 20
    color: backgroundColor

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    
    Text {
        id: label
        text: "Button"
        color: colors.fontColorFor( button.color )
        x: 10
        y: 5
    }
    
    MouseArea {
        anchors.fill: parent
        id: mouseArea
        hoverEnabled: true
        
        onClicked: button.clicked()
    }
    
    states: [
        State {
            name: "down"
            when: pressed || containsMouse || button.down
            PropertyChanges {
                target: button
                color: button.highlightColor
            }
        }
    ]
    
}
