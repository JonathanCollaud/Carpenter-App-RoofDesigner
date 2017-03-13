import "." // to import Settings
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4

import SketchConverter 1.0
import SketchStaticsExporter 1.0

MenuBar {
    id: menuBar

    property var sketchScreenLoader
    property var sketch: sketchScreenLoader.item.sketch

    Menu {
        title: "File"
        MenuItem {
            text: "New sketch"
            shortcut: Settings.shortcutNewSketch
            onTriggered: {
                if(QtMultimedia.availableCameras.length === 0) {
                    message.displayErrorMessage("No camera available");
                }
                else {
                    captureImageLoader.source = "qrc:/CaptureImage.qml"
                    sketchScreenLoader.source = ""
                }
            }
        }
        MenuItem {
            text: "Open a sketch"
            shortcut: Settings.shortcutOpenSketch
            onTriggered: {
                fileDialogLoader.source = "OpenFileDialog.qml"
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "Save the sketch"
            shortcut: Settings.shortcutSaveSketch
            onTriggered: {
                fileDialogLoader.source = "SaveFileDialog.qml"
            }
            property SketchStaticsExporter staticsExporter: SketchStaticsExporter {
                sketch: sketchScreenLoader.item.sketch }
        }
        MenuItem {
            text: "Export as 3D"
            shortcut: Settings.shortcutExport3D
            onTriggered: {
                var basename=new Date().toLocaleString(Qt.locale(),"dMyyhms");

                var staticsExportResult = staticsExporter.exportToFile(basename,Settings.defaultCaptureImagePath,Qt.size(mainForm.width,mainForm.height));
                console.log("staticsExportResult", staticsExportResult);

                var exportResult = converter.exportToFile(sketch, basename);
                console.log("exportResult: ", exportResult);

                if(exportResult === true) {
                    if(staticsExportResult !== true) {
                        message.displayErrorMessage("Text file export failed: " + staticsExportResult)
                    }
                    else {
                        message.displaySuccessMessage("3D export succeed")
                    }
                }
                else {
                    message.displayErrorMessage("3D export failed : " + exportResult);
                }
            }
            property SketchConverter converter: SketchConverter { }
            property SketchStaticsExporter staticsExporter: SketchStaticsExporter {
                sketch: sketch }
        }
    }

    Menu {
        title: "Edit"
        MenuItem {
            text: "Undo"
            shortcut: Settings.shortcutUndo
            enabled: Settings.canUndo
            onTriggered: {
                sketch.undo()
            }
        }
        MenuItem {
            text: "Redo"
            shortcut: Settings.shortcutRedo
            enabled: Settings.canRedo
            onTriggered: {
                sketch.redo()
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "Select"
            shortcut: Settings.shortcutSelectTool
            onTriggered: {
                sketchScreenLoader.item.changeTool("SelectTool", "select from key")
            }
        }
        MenuItem {
            text: "Insert"
            shortcut: Settings.shortcutInsertTool
            onTriggered: {
                sketchScreenLoader.item.changeTool("InsertTool", "insert from key")
            }
        }
        MenuItem {
            text: "Move"
            shortcut: Settings.shortcutMoveTool
            onTriggered: {
                sketchScreenLoader.item.changeTool("MoveTool", "move from key")
            }
        }
        MenuItem {
            text: "Delete"
            shortcut: Settings.shortcutDeleteTool
            onTriggered: {
                sketchScreenLoader.item.changeTool("DeleteTool", "delete from key")
            }
        }
    }

    Menu {
        title: "View"
        MenuItem {
            text: "Display background"
            shortcut: Settings.shortcutDislplayBackground
            checkable: true
            checked: sketch.isBackgroundSet()
            onTriggered: {
                sketch.enableBackground(this.checked)
            }
        }
        MenuItem {
            text: "Display grid"
            shortcut: Settings.shortcutDislplayGrid
            checkable: true
            checked: Settings.backgroundGridEnable
            onTriggered: {
                Settings.backgroundGridEnable = !Settings.backgroundGridEnable
            }
        }
        MenuItem {
            text: "Display help tip"
            shortcut: Settings.shortcutDislplayHelpTip
            checkable: true
            checked: Settings.helpTipEnable
            onTriggered: {
                Settings.helpTipEnable = !Settings.helpTipEnable
            }
        }
        MenuItem {
            text: "Display ruler"
            shortcut: Settings.shortcutDislplayRuler
            checkable: true
            checked: Settings.rulerEnable
            onTriggered: {
                Settings.rulerEnable = !Settings.rulerEnable
            }
        }
    }

    Menu {
        title: "Old stuff"

        MenuItem {
            text: "Login"
            shortcut: Settings.shortcutLogin
            onTriggered: {
                loginFormLoader.source = "qrc:/LoginForm.qml"
                sketchScreenLoader.source = ""
            }
        }

        MenuItem {
            text: "Back to Welcome Screen"
            shortcut: Settings.shortcutWelcomeScreen
            onTriggered: {
                welcomeScreenLoader.source = "qrc:/WelcomeScreen.qml"
                sketchScreenLoader.source = ""
            }
        }

        MenuItem {
            text: "Set background"
            onTriggered: {
                if(QtMultimedia.availableCameras.length === 0) {
                    message.displayErrorMessage("No camera available");
                }
                else {
                    captureImageLoader.source = "qrc:/CaptureImage.qml"
                    sketchScreenLoader.source = ""
                }
            }
        }

        MenuItem {
            text: "Apply constraints"
            shortcut: Settings.shortcutApplyConstraints
            onTriggered: {
                var solveResult = mouseArea.constraintsSolver.solve()
                console.log("solveResult: ", solveResult);
                if(solveResult === true) {
                    mouseArea.constraintsSolver.applyOnSketch();
                    message.displaySuccessMessage("Constraints application succeed")
                }
                else {
                    message.displayErrorMessage("Constraints application failed : " + solveResult)
                }
            }
        }
    }
}



