import QtQuick 2.5
import QtQuick.Controls 2.2

import OpenTodoList 1.0
import OpenTodoList.UI 1.0

Item {
    id: page
    
    property Note item: Note {}
    property var library: null
    property StackView stack: null

    
    function cancel() {
    }
    
    function deleteItem() {
        confirmDeleteDialog.open();
    }
    
    Dialog {
        id: confirmDeleteDialog
        title: qsTr("Delete Note?")

        Text {
            text: qsTr("Are you sure you want to delete the note <strong>%1</strong>? This action " +
                       "cannot be undone.").arg(item.title)
            width: 300
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            item.deleteItem();
            stack.pop();
        }
    }
    
    RenameItemDialog {
        id: renameItemDialog
    }

    Rectangle {
        color: Qt.lighter(Colors.itemColor(item.color), 1.1)
        opacity: 0.3
        anchors.fill: parent
    }
    
    ScrollView {
        id: scrollView
        
        anchors.fill: parent
        
        Column {
            width: scrollView.width
            spacing: Globals.defaultMargin
            
            MouseArea {
                onClicked: renameItemDialog.renameItem(item)
                height: childrenRect.height
                width: parent.width
                cursorShape: Qt.PointingHandCursor
                
                Label {
                    text: item.title
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Globals.defaultMargin
                    }
                    font {
                        bold: true
                        pixelSize: Globals.fontPixelSize * 2
                    }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
            
            StickyNote {
                id: note
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Globals.defaultMargin
                }
                title: qsTr("Notes")
                text: item.notes
                backgroundColor: item.color === TopLevelItem.White ? Colors.noteBackground : Colors.itemWhite
                onClicked: {
                    var page = stack.push(notesEditor, { text: item.notes });
                    page.onTextChanged.connect(function() { item.notes = page.text; });
                    item.onReloaded.connect(function() { page.text = item.notes; });
                    
                }
            }
            
            Component {
                id: notesEditor
                
                RichTextEditor {
                    Component.onCompleted: forceActiveFocus()
                }
            }
            
            TagsEditor {
                item: page.item
                library: page.library
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Globals.defaultMargin * 2
                }
            }
            
            Item {
                height: Globals.defaultMargin
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Globals.defaultMargin * 2
                }
            }
        }
    }
}




