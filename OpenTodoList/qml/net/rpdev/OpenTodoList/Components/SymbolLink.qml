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
import net.rpdev.OpenTodoList.Theme 1.0

Item {
    id: link

    property alias color: symbolLabel.color
    property alias symbol: symbolLabel.symbol
    property int minWidth: Measures.mHeight * 2
    property int minHeight: Measures.mHeight * 2

    signal clicked()

    width: Math.max( symbolLabel.width, minWidth )
    height: Math.max( symbolLabel.height, minHeight )

    Symbol {
        id: symbolLabel
        color: Colors.midText
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: link.clicked()
    }
}

