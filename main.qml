import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 850
    color: "#010305"
    title: "JARVIS SYSTEM OS"

    property string state: "idle"
    property string displayResponse: "SYSTEM READY // ONLINE"
    property color jarvisBlue: "#00d2ff"
    property color glowColor: "#4000d2ff"

    // --- Background Layer ---
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0a1a2d" }
            GradientStop { position: 1.0; color: "#010305" }
        }

        // Circuit Grid Canvas
        Canvas {
            anchors.fill: parent
            opacity: 0.3
            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = jarvisBlue;
                ctx.lineWidth = 0.5;
                
                // Draw Grid
                for(var i=0; i<width; i+=40) {
                    ctx.beginPath();
                    ctx.moveTo(i, 0); ctx.lineTo(i, height);
                    ctx.stroke();
                }
                for(var j=0; j<height; j+=40) {
                    ctx.beginPath();
                    ctx.moveTo(0, j); ctx.lineTo(width, j);
                    ctx.stroke();
                }
            }
        }
    }

    // --- HUD Elements ---
    // Corner Brackets
    Item {
        anchors.fill: parent
        anchors.margins: 20
        
        Repeater {
            model: 4
            Rectangle {
                width: 40; height: 40
                color: "transparent"
                border.color: jarvisBlue
                border.width: 2
                
                x: index % 2 === 0 ? 0 : parent.width - width
                y: index < 2 ? 0 : parent.height - height
                
                // Hide parts to make brackets
                Rectangle { 
                    width: parent.width - 10; height: parent.height - 10
                    anchors.centerIn: parent; color: "#010305" 
                }
            }
        }
    }

    // Scanning Line
    Rectangle {
        width: parent.width; height: 2
        color: jarvisBlue
        opacity: 0.5
        y: 0
        SequentialAnimation on y {
            loops: Animation.Infinite
            NumberAnimation { from: 0; to: 850; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 850; to: 0; duration: 4000; easing.type: Easing.InOutQuad }
        }
    }

    // --- Text Display ---
    Rectangle {
        id: textContainer
        width: 540; height: 200
        anchors.top: parent.top; anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#15ffffff"
        radius: 15
        border.color: "#30ffffff"
        border.width: 1
        clip: true

        // Glassmorphism effect overlay
        Rectangle {
            anchors.fill: parent
            radius: 15
            color: "transparent"
            border.color: jarvisBlue
            border.width: state === "processing" ? 2 : 0
            opacity: 0.5
        }

        ScrollView {
            anchors.fill: parent
            anchors.margins: 15
            padding: 10

            Text {
                text: displayResponse
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: jarvisBlue
                font.pixelSize: 18
                font.family: "Courier New"
                font.bold: true
                
                SequentialAnimation on opacity {
                    running: state === "processing"
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.5; to: 1.0; duration: 400 }
                    NumberAnimation { from: 1.0; to: 0.5; duration: 400 }
                }
            }
        }
    }

    // --- The Arc Reactor Core ---
    Item {
        id: jarvisCore
        width: 400; height: 400
        anchors.centerIn: parent

        // Outer Conical RGB Ring
        Rectangle {
            anchors.fill: parent
            radius: 200
            color: "transparent"
            
            RotationAnimation on rotation {
                from: 0; to: 360; duration: 8000
                loops: Animation.Infinite; running: true
            }

            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var grad = ctx.createConicalGradient(width/2, height/2, 0);
                    grad.addColorStop(0.0, "#00d2ff");
                    grad.addColorStop(0.5, "#0055ff");
                    grad.addColorStop(1.0, "#00d2ff");
                    ctx.strokeStyle = grad;
                    ctx.lineWidth = 4;
                    ctx.setLineDash([10, 5]);
                    ctx.beginPath();
                    ctx.arc(width/2, height/2, width/2 - 10, 0, 2 * Math.PI);
                    ctx.stroke();
                }
            }
        }

        // Inner Rotating Ring
        Rectangle {
            width: 320; height: 320; radius: 160
            anchors.centerIn: parent
            color: "transparent"
            border.color: "#3000d2ff"
            border.width: 2
            
            RotationAnimation on rotation {
                from: 360; to: 0; duration: 12000
                loops: Animation.Infinite; running: true
            }
            
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.strokeStyle = "#8000d2ff";
                    ctx.lineWidth = 2;
                    ctx.setLineDash([2, 10]);
                    ctx.beginPath();
                    ctx.arc(width/2, height/2, width/2 - 5, 0, 2 * Math.PI);
                    ctx.stroke();
                }
            }
        }

        // Central Core with Logo
        Rectangle {
            width: 180; height: 180; radius: 90
            anchors.centerIn: parent
            color: "#1000d2ff"
            border.color: jarvisBlue
            border.width: 2

            Image {
                id: logoImg
                source: "assets/logo.png"
                anchors.fill: parent
                anchors.margins: 20
                fillMode: Image.PreserveAspectFit
                opacity: 0.8
            }

            // Pulsing Glow
            Rectangle {
                anchors.fill: parent
                radius: 90
                color: "transparent"
                border.color: jarvisBlue
                border.width: 4
                opacity: 0
                
                SequentialAnimation on scale {
                    running: state === "speaking" || state === "listening"
                    loops: Animation.Infinite
                    ParallelAnimation {
                        NumberAnimation { from: 1.0; to: 1.4; duration: 1000 }
                        NumberAnimation { target: parent; property: "opacity"; from: 0.8; to: 0; duration: 1000 }
                    }
                }
            }
        }

        MouseArea { 
            anchors.fill: parent
            hoverEnabled: true
            onClicked: bridge.start_listening()
            onEntered: coreGlow.opacity = 0.5
            onExited: coreGlow.opacity = 0.2
        }
        
        Rectangle {
            id: coreGlow
            anchors.fill: parent
            radius: 200
            opacity: 0.2
            gradient: Gradient {
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1.0; color: "#2000d2ff" }
            }
        }
    }

    // --- Input Field ---
    TextField {
        id: textInput
        width: 520; height: 55
        anchors.bottom: parent.bottom; anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: "TYPE COMMAND SIR..."
        placeholderTextColor: "#80ffffff"
        color: "white"
        font.pixelSize: 16
        font.family: "Monospace"
        leftPadding: 20
        
        background: Rectangle {
            color: "#15ffffff"
            radius: 10
            border.color: textInput.activeFocus ? jarvisBlue : "#40ffffff"
            border.width: 2
            
            Rectangle {
                anchors.fill: parent; anchors.margins: -2
                radius: 12; color: "transparent"
                border.color: jarvisBlue; border.width: 1
                visible: textInput.activeFocus
                opacity: 0.3
            }
        }
        
        onAccepted: {
            bridge.handle_text_input(text)
            text = ""
        }
    }

    Connections {
        target: bridge
        function onUpdateState(s) { state = s }
        function onUpdateText(t) { displayResponse = t.toUpperCase() }
    }
}