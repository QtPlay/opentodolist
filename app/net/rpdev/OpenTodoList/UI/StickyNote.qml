import QtQuick 2.0
import QtGraphicalEffects 1.0

import net.rpdev.OpenTodoList.UI 1.0

MouseArea {
    id: note
    
    property string title: qsTr("Sticky Note Title")
    property string text: qsTr("Note Content")
    property color backgroundColor: Colors.noteBackground
    
    property int __shadowOffset: hoverEnabled && containsMouse ? Globals.defaultMargin : 0
    
    implicitWidth: 200
    implicitHeight: titleLabel.height + contentLabel.height + Globals.defaultMargin * 6
    
    Behavior on __shadowOffset { SmoothedAnimation { duration: 500 } }
    
    Rectangle {
        id: shadow
        anchors {
            fill: parent
            leftMargin: Globals.defaultMargin * 2 + __shadowOffset
            topMargin: Globals.defaultMargin * 2 + __shadowOffset
            rightMargin: Globals.defaultMargin * 0.5 - __shadowOffset
            bottomMargin: Globals.defaultMargin * 0.5 - __shadowOffset
        }
        color: "black"
        opacity: note.hoverEnabled & note.containsMouse ? 0.5 : 0.1
        Behavior on opacity { SmoothedAnimation { duration: 500 } }
    }
    
    Image {
        id: texture
        source: "lightpaperfibers/lightpaperfibers.png"
        fillMode: Image.Tile
        anchors.fill: notesItemBackground
        anchors.margins: 1
    }
    
    ColorOverlay {
        source: texture
        anchors.fill: texture
        color: Colors.makeTransparent(backgroundColor, 0.5)
    }
    
    Rectangle {
        id: notesItemBackground
        anchors {
            fill: parent
            margins: Globals.defaultMargin - __shadowOffset * 0.5
        }
        color: "transparent"
        border {
            width: 1
            color: Qt.darker(backgroundColor, 1.2)
        }
    }
    
    Item {
        id: notesItem
        
        anchors {
            fill: notesItemBackground
            margins: 0
            bottomMargin: 1
        }
        clip: true
        
        Rectangle {
            id: titleLabelBackground
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: titleLabel.height + Globals.defaultMargin * 2
            color: "black"
            opacity: 0.1
        }

        Text {
            id: titleLabel
            
            text: title
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: Globals.defaultMargin
            }
            font.bold: true
            elide: Text.ElideRight
        }
        
        Text {
            id: contentLabel
            
            text: note.text
            anchors {
                left: parent.left
                right: parent.right
                top: titleLabelBackground.bottom
                margins: Globals.defaultMargin
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.RichText
        }
    }
}