import QtQuick 2.0
import QtQuick.Dialogs 1.0

FileDialog {
    id: openFileDialog
    title: "Please choose a file"
    folder: shortcuts.desktop
    nameFilters: [ "Carpenter files (*.obj, *.carp)" ]

    property var sketchScreenLoader
    property var sketch: sketchScreenLoader.item.sketch

    onAccepted: {
        console.log("You've openned: " + openFileDialog.fileUrls)
        viewer3dLoader.active=true;
        viewer3dLoader.meshSource = fileURL
    }
    onRejected: {
        console.log("Open canceled")
    }
    Component.onCompleted: visible = true

}
