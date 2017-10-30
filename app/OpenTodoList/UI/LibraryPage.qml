import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2

import OpenTodoList 1.0
import OpenTodoList.UI 1.0

import "LibraryPageLogic.js" as Logic

Page {
    id: page

    property Library library: null
    property string tag: ""

    signal itemClicked(TopLevelItem item)
    signal closePage()
    signal openPage(var component, var properties)

    function newNote() {
        newNoteBar.edit.forceActiveFocus();
        newNoteBar.edit.text = "";
    }

    function newTodoList() {
        newTodoListBar.edit.forceActiveFocus();
        newTodoListBar.edit.text = "";
    }

    function newImage() {
        openImageDialog.open();
    }

    function find() {
        filterBar.edit.forceActiveFocus()
    }

    property var deleteItem: library === App.defaultLibrary ? null :
                                                              function() {
                                                                  confirmDeleteLibrary.open();
                                                              }
    property bool syncRunning: library && library.synchronizing
    property Menu pageMenu: Menu {
        x: page.width

        MenuItem {
            text: qsTr("Edit Sync Settings")
            enabled: page.library.hasSynchronizer
            onClicked: {
                var sync = page.library.createSynchronizer();
                if (sync !== null) {
                    var key = sync.secretsKey;
                    if (key !== "") {
                        sync.secret = App.secretForSynchronizer(sync);
                    }
                    var url = Qt.resolvedUrl(sync.type + "SettingsPage.qml");
                    page.openPage(url, {"synchronizer": sync});
                }
            }
        }

        MenuItem {
            text: qsTr("Sync Now")
            enabled: page.library.hasSynchronizer
            onClicked: {
                console.debug("Manually started syncing " + page.library.name);
                App.syncLibrary(library);
            }
        }
    }

    clip: true

    CenteredDialog {
        id: confirmDeleteLibrary
        title: qsTr("Delete Library?")
        Text {
            text: qsTr("Do you really want to remove the library <strong>%1</strong> from the " +
                       "application? Note that the files inside the library will not be removed, so " +
                       "you can restore the library later on.").arg(library.name)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: 300
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            library.deleteLibrary();
        }
    }

    CenteredDialog {
        id: confirmDeleteItem
        title: qsTr("Delete Item?")
        Text {
            text: qsTr("Do you really want to delete the item <strong>%1</strong> from the library? " +
                       "This action cannot be undone!").arg(
                      itemContextMenu.item ? itemContextMenu.item.title : "")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: 300
        }
        standardButtons:Dialog.Ok |Dialog.Cancel
        onAccepted: itemContextMenu.item.deleteItem()
    }

    RenameItemDialog {
        id: renameItemDialog
    }

    CreateNewTagDialog {
        id: createNewTagDialog
    }

    Menu {
        id: itemContextMenu

        property TopLevelItem item: null

        onItemChanged: tagsMenu.rebuild()

        Menu {
            title: qsTr("Color")

            MenuItem {
                text: qsTr("Red")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Red
            }
            MenuItem {
                text: qsTr("Green")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Green
            }
            MenuItem {
                text: qsTr("Blue")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Blue
            }
            MenuItem {
                text: qsTr("Yellow")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Yellow
            }
            MenuItem {
                text: qsTr("Orange")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Orange
            }
            MenuItem {
                text: qsTr("Lilac")
                onTriggered: itemContextMenu.item.color = TopLevelItem.Lilac
            }
            MenuItem {
                text: qsTr("White")
                onTriggered: itemContextMenu.item.color = TopLevelItem.White
            }
        }

        MenuItem {
            text: qsTr("Rename")
            onTriggered: renameItemDialog.renameItem(itemContextMenu.item)
        }

        Menu {
            id: tagsMenu

            title: qsTr("Tags")

            function rebuild() {
                while (contentData.length > 0) {
                    removeItem(contentData[0]);
                }
                var topLevelItem = itemContextMenu.item;
                var item = addItem(qsTr("Create new tag..."));
                item.onTriggered.connect(function() {
                    createNewTagDialog.addTag(topLevelItem);
                });

                var tags = page.library.tags;
                for (var i = 0; i < tags.length; ++i) {
                    var tag = tags[i];
                    __addTagMenuItem(tag);
                }
            }

            function __addTagMenuItem(tag) {
                var topLevelItem = itemContextMenu.item;
                var item = addItem(tag);
                item.checkable = true;
                item.checked = Qt.binding(function() {
                    return topLevelItem.tags.indexOf(tag) >= 0;
                });
                item.onTriggered.connect(function() {
                    if (topLevelItem.hasTag(tag)) {
                        topLevelItem.removeTag(tag);
                    } else {
                        topLevelItem.addTag(tag);
                    }
                });
            }

            /*Connections {
                target: page.library
                onTagsChanged: tagsMenu.rebuild();
            }*/
        }

        MenuItem {
            text: qsTr("Delete")
            onTriggered: confirmDeleteItem.open()
        }
    }

    OpenFileDialog {
        id: openImageDialog

        title: qsTr("Add Image to Library")
        nameFilters: ["*.png", "*.bmp", "*.jpg", "*.jpeg", "*.gif"]

        onAccepted: {
            var image = library.addImage();
            var filename = App.urlToLocalFile(fileUrl);
            image.image = filename;
            image.title = App.basename(filename);
            if (leftSideBar.currentTag !== "") {
                image.addTag(leftSideBar.currentTag);
            }
        }
    }

    ItemsSortFilterModel {
        id: itemsModel
        sourceModel: ItemsModel {
            container: page.library.topLevelItems
        }
    }

    ItemsSortFilterModel {
        id: filteredItemsModel

        sourceModel: itemsModel
        tag: page.tag
        searchString: filterBar.text
    }

    TextInputBar {
        id: newNoteBar
        placeholderText: qsTr("Note Title")
        onAccepted: {
            var note = Logic.createNote(library, newNoteBar.edit);
            if (openItem) {
                itemClicked(note);
            }
            if (leftSideBar.currentTag !== "") {
                note.addTag(leftSideBar.currentTag)
            }
        }
    }

    TextInputBar {
        id: newTodoListBar
        placeholderText: qsTr("Todo List Title")
        onAccepted: {
            var todoList = Logic.createTodoList(library, newTodoListBar.edit);
            if (openItem) {
                itemClicked(todoList);
            }
            if (leftSideBar.currentTag !== "") {
                todoList.addTag(leftSideBar.currentTag)
            }
        }
    }

    TextInputBar {
        id: filterBar
        placeholderText: qsTr("Search term 1, search term 2, ...")
        symbol: Fonts.symbols.faTimes
        color: Colors.secondary2
        itemCreator: false
        showWhenNonEmpty: true
        closeOnButtonClick: true
    }

    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: filterBar.bottom
            topMargin: filterBar.shown ? filterBar.contentHeight - filterBar.height : 0
        }

        GridView {
            id: grid
            width: scrollView.width
            flow: GridView.LeftToRight
            model: filteredItemsModel
            cellWidth: Logic.sizeOfColumns(scrollView)
            cellHeight: cellWidth / 3 * 2
            delegate: Loader {
                asynchronous: true
                width: grid.cellWidth
                height: grid.cellHeight
                source: Qt.resolvedUrl(object.itemType + "Item.qml")

                onLoaded: {
                    item.libraryItem = object;
                    item.library = page.library;
                    item.onClicked.connect(function() {

                    });
                    item.onReleased.connect(function(mouse) {
                        switch (mouse.button) {
                        case Qt.LeftButton:
                            itemClicked(object);
                            break;
                        case Qt.RightButton:
                            itemContextMenu.item = object;
                            itemContextMenu.open();
                            break;
                        default:
                            break;
                        }
                    });
                }
            }
        }
    }

    LibrarySecretsMissingNotificationBar {
        library: page.library
    }
}