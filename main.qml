import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0

import "." // to import Settings
import "qrc:/tools/tools/SelectTool.js" as SelectTool
import "qrc:/tools/tools/InsertTool.js" as InsertTool
import "qrc:/tools/tools/MoveTool.js" as MoveTool
import "qrc:/tools/tools/DeleteTool.js" as DeleteTool

import SketchConverter 1.0
import SketchConstraintsSolver 1.0
import SketchStaticsExporter 1.0
import DisplayKeyboard 1.0
import RealtoExporter 1.0

ApplicationWindow {
    visible: true
    width: Settings.appWidth
    height: Settings.appHeight
    visibility: "Maximized"

    Loader {
        id: menuBarLoader
        width: parent.width
    }

    Loader{
        id: fileDialogLoader
    }

    MainForm {
        id: mainForm
        anchors.fill: parent

        Loader {
            id: splashScreenLoader
            source: "qrc:/SplashScreen.qml"
            anchors.fill: parent
        }

        Loader {
            id: welcomeScreenLoader
            anchors.fill: parent
        }

        Loader {
            id: loginFormLoader
            anchors.fill: parent
        }

        Loader {
            id: sketchScreenLoader
            anchors.fill: parent
            onStatusChanged: {
                if (status == Loader.Ready){
                    console.log(status)
                }
            }
        }

        Loader {
            id: captureImageLoader
            anchors.fill: parent
        }

        Loader {
            Component.onCompleted: this;
        }

        FontLoader { source: "fonts/Material-Design-Iconic-Font.ttf" }

        FontLoader { source: "fonts/FontAwesome.otf" }

        Loader{
            id:viewer3dLoader
            anchors.fill:parent;
            source: "qrc:/Viewer3D.qml"
            asynchronous: true
            active: false
            property url meshSource;
            onStatusChanged: {
                if(status == Loader.Ready){
                    item.mesh.source=meshSource;
                }
            }
        }

        DisplayKeyboard {
            id: displayKeyboard
        }

        RealtoExporter{
            id:realtoExporter
            onError: {
                message.displayErrorMessage(err);
            }
        }
    }
}

