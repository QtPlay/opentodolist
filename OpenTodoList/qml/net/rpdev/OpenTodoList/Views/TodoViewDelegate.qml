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
import net.rpdev.OpenTodoList.Core 1.0
import net.rpdev.OpenTodoList.Components 1.0
import net.rpdev.OpenTodoList.Theme 1.0

Item {
    id: delegate

    property Todo todo

    signal clicked()

    height: rectangle.height + 2 * Measures.tinySpace
    anchors {
        left: parent.left
        right: parent.right
    }

    Rectangle {
        id: rectangle
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Measures.tinySpace
        }
        height: label.height + Measures.tinySpace * 2
        color: Colors.listItem

        Symbol {
            id: checkMark
            symbol: todo && todo.progress >= 100 ? checkedBox : uncheckedBox
            anchors {
                left: parent.left
                verticalCenter: label.verticalCenter
            }
        }

        Label {
            id: label
            text: todo ? todo.title : ""
            font.strikeout: todo && todo.isDeleted ? true : false
            anchors {
                left: checkMark.right
                right: parent.right
                top: parent.top
                margins: Measures.tinySpace
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
        Label {
            id: placeholder
            visible: label.text === ""
            text: qsTr( "Untitled Todo" )
            font.strikeout: label.font.strikeout
            color: Colors.midText
            anchors.fill: label
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
    MouseArea {
        anchors.fill: rectangle
        onClicked: delegate.clicked()
    }
}
