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

import QtQuick 2.0
import net.rpdev.OpenTodoList.Components 1.0

FocusScope {
    id: overlay
    state: "available"

    property bool autoClose: false
    property bool closeOnBackPressed: true
    property alias backgroundOpacity: rectangle.opacity

    function show() {
        while ( parent.parent && parent.parent.parent ) {
            parent = parent.parent
        }
        anchors.fill = parent;
        state = "showing"
        focus = true;
    }

    function close() {
        state = "closing";
        parent.focus = true;
    }

    Keys.onEscapePressed: if ( closeOnBackPressed ) close()
    Keys.onBackPressed: if ( closeOnBackPressed ) close()

    opacity: 0.0

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if ( overlay.autoClose ) close()
    }

    states: [
        State {
            name: "showing"
            PropertyChanges {
                target: overlay
                opacity: 1.0
            }
        },
        State {
            name: "closing"
            PropertyChanges {
                target: overlay
                opacity: 0.0
            }
        }
    ]

    transitions: [
        Transition {
            from: "available"
            to: "showing"
            NumberAnimation {
                properties: "opacity"
                duration: 500
            }
        },
        Transition {
            from: "showing"
            to: "closing"
            SequentialAnimation {
                NumberAnimation {
                    properties: "opacity"
                    duration: 500
                }
                ScriptAction {
                    script: overlay.destroy()
                }
            }
        }
    ]
}
