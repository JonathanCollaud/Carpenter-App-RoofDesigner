import QtQuick 2.0
import QtQuick.Window 2.0
Rectangle {
    property var p1;
    property var p2;

    readonly property string class_type: "Line"

    visible: existing

    property bool existing: private_existing ?
                                ( p1 && p2 ?  p1.existing && p2.existing && p1!==p2 : false):false

    property bool private_existing: true
    property alias mouse_area:mouse_area

    property var undo_buffer:[]
    property var redo_buffer:[]
    Component.onCompleted: {
        console.log("new line")
        antialiasing=true
    }
    height: parent.class_type ? Screen.pixelDensity*2*1/(parent.zoomFactor) : 3
    width: p1 && p2? Math.sqrt(Math.pow((p1.x-p2.x),2)+Math.pow((p1.y-p2.y),2)) :0

    Connections{
        ignoreUnknownSignals: false
        target: parent && parent.class_type ? parent : null
        onStore_state: store_state(epoch)
        onUndo: undo()
        onRedo: redo()
    }

    function undo(){
        if(undo_buffer.length>0){
            redo_buffer.push(undo_buffer.pop())
            if(undo_buffer.length>0){
                var state=undo_buffer[undo_buffer.length-1]
                p1=state.p1
                p2=state.p2
                private_existing=state.private_existing
            }else
                private_existing=false
        }
    }

    function redo(){
        if(redo_buffer.length>0){
            var state=redo_buffer.pop()
            p1=state.p1
            p2=state.p2
            private_existing=state.private_existing
            undo_buffer.push(state)
        }
    }

    function store_state(epoch){
        if(undo_buffer.length!=epoch-1){
            for(var i=0;i<epoch-1;i++)
                undo_buffer.push({'p1':null,'p2':null,'private_existing':false})
        }
        var state={'p1':p1,'p2':p2,'private_existing':private_existing}
        undo_buffer.push(state)
        redo_buffer=[]
    }

    Connections{
        ignoreUnknownSignals: true
        target: p1 ? p1:null
        onReplaceMe: {
                p1=replacement
        }
    }

    Connections{
        ignoreUnknownSignals: true
        target: p2 ? p2:null
        onReplaceMe: {
                p2 = replacement
        }
    }

    function kill(){
        private_existing=false
    }

    anchors.left: if(p1) return p1.horizontalCenter
    anchors.verticalCenter: if(p1) return p1.verticalCenter
    transformOrigin: Item.Left
    rotation: p1 && p2 ? Math.atan2(p2.y-p1.y,p2.x-p1.x)*180/Math.PI : 0

    antialiasing: true
    color:"grey"

    MouseArea{
        id:mouse_area
        drag.smoothed: false
        preventStealing:true
        anchors.fill: parent
        onPressed: {current_tool.onPressed(parent,mouse);}
        onReleased: {current_tool.onReleased(parent,mouse);}
        onClicked: {current_tool.onClicked(parent,mouse);}
        onCanceled: {current_tool.abort();}
        enabled: parent.class_type
    }
}
