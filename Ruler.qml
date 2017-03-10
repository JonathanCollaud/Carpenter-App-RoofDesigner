import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "." // to import Settings

Rectangle {
    id: ruler

    visible: Settings.rulerEnable

    width: childrenRect.width
    height: childrenRect.height

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 10
    color: "white"

    property var availableUnits: {
        "0" : "mm",
        "1" : "cm",
        "2" : "dm",
        "3" : "m",
        "4" : "dam",
        "5" : "hm",
        "6" : "km"
    }

    property var scale: visible ? sketch.getMmPerPixelScale() : 0;
    property bool first : true;

    onScaleChanged: {
        if(first && sketch.isMmPerPixelScaleSet()) {
            first = false;
            var mmPerPixelScale = sketch.getMmPerPixelScale();
            var mmDistanceFor100px = 100 * mmPerPixelScale;
            var order = Math.floor(Math.log(mmDistanceFor100px) / Math.LN10);

            //ruler.height = Math.ceil(Math.pow(10, order) / mmPerPixelScale);
            scaleRuleSize.width = 100;
            scaleRuleText.text = (function(order) {
                if(order >= 0 && order <= 6) {
                    return "1 " + ruler.availableUnits[order.toString(10)];
                }
                else if(order > 6) {
                    return Math.pow(10, order-6) + " " + ruler.availableUnits["6"];
                }
                else if(order < 0) {
                    return Math.pow(10, order) + " " + ruler.availableUnits["0"];
                }
            })(order);
        }
    }

    RowLayout {
        width: scaleRuleText.width + scaleRuleSize.width + 15

        Label {
            id: scaleRuleText
            text: ""
            anchors.left: parent.left
            anchors.margins: 5
        }

        Rectangle {
            id: scaleRuleSize
            height: 2
            anchors.verticalCenter: scaleRuleText.verticalCenter
            color: "black"
            anchors.right: parent.right
            anchors.margins: 5
        }
    }
}

