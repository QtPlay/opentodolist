import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import net.rpdev.OpenTodoList 1.0
import net.rpdev.OpenTodoList.UI 1.0

Item {
    id: page
    
    property Note item: Note {}
    property StackView stack: null
    property bool __visible: Stack.status === Stack.Active
    
    function cancel() {
        item.title = titleEdit.text;
    }
    
    function deleteItem() {
        confirmDeleteDialog.open();
    }
    
    MessageDialog {
        id: confirmDeleteDialog
        title: qsTr("Delete Note?")
        text: qsTr("Are you sure you want to delete the note <strong>%1</strong>? This action " +
                   "cannot be undone.").arg(item.title)
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            item.deleteItem();
            stack.pop();
        }
    }

    Rectangle {
        color: Qt.lighter(Colors.itemColor(item.color), 1.1)
        opacity: 0.3
        anchors.fill: parent
    }
    
    ScrollView {
        id: scrollView
        
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        anchors.fill: parent
        
        Item {
            width: scrollView.viewport.width
            height: childrenRect.height
            
            TextInput {
                id: titleEdit
                text: item.title
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: Globals.defaultMargin
                }
                font {
                    bold: true
                    pixelSize: Globals.fontPixelSize * 2
                }
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                Keys.onEscapePressed: focus = false
                Keys.onBackPressed: focus = false
                Keys.onReturnPressed: focus = false
                Keys.onEnterPressed: focus = false
            }
            
            StickyNote {
                id: note
                anchors {
                    left: parent.left
                    right: parent.right
                    top: titleEdit.bottom
                    margins: Globals.defaultMargin
                }
                title: qsTr("Notes")
                text: item.notes
                backgroundColor: item.color === TopLevelItem.White ? Colors.noteBackground : Colors.itemWhite
                onClicked: stack.push({ item: notesEditor, properties: { text: item.notes }});
            }
            
            Component {
                id: notesEditor
                
                RichTextEditor {
                    onAccepted: page.item.notes = text
                }
            }
        }
    }
}



