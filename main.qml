import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 600
    height: 850
    color: "#010305"
    title: "JARVIS SYSTEM OS"

    property string state: "idle"
    property string displayResponse: "SYSTEM READY // ONLINE"
    property color jarvisBlue: "#00d2ff"

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0a1a2d" }
            GradientStop { position: 1.0; color: "#010305" }
        }
    }

    Text {
        text: displayResponse
        anchors.top: parent.top
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        width: 500
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        color: jarvisBlue
        font.pixelSize: 22
        font.family: "Monospace"
        font.bold: true
    }

    Item {
        id: jarvisCore
        width: 450
        height: 450
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            radius: 225
            color: "transparent"
            border.width: 4
            opacity: 0.8

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 3000
                loops: Animation.Infinite
                running: true
            }

            Rectangle {
                anchors.fill: parent
                radius: 225
                color: "transparent"
                border.width: 4
                border.color: "transparent"
                
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        var gradient = ctx.createConicalGradient(width/2, height/2, 0);
                        gradient.addColorStop(0.0, "red");
                        gradient.addColorStop(0.17, "yellow");
                        gradient.addColorStop(0.33, "green");
                        gradient.addColorStop(0.5, "cyan");
                        gradient.addColorStop(0.67, "blue");
                        gradient.addColorStop(0.83, "magenta");
                        gradient.addColorStop(1.0, "red");
                        ctx.strokeStyle = gradient;
                        ctx.lineWidth = 4;
                        ctx.beginPath();
                        ctx.arc(width/2, height/2, width/2 - 2, 0, 2 * Math.PI);
                        ctx.stroke();
                    }
                }
            }
        }

        Rectangle {
            width: 140
            height: 140
            radius: 70
            anchors.centerIn: parent
            color: "#1500d2ff"
            border.color: "#ffffff"
            border.width: 2

            Rectangle {
                anchors.fill: parent
                radius: 70
                color: jarvisBlue
                opacity: 0.3
                scale: 1.2
            }

            SequentialAnimation on scale {
                running: state === "speaking"
                loops: Animation.Infinite
                NumberAnimation { to: 1.3; duration: 250; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 250; easing.type: Easing.InOutQuad }
            }

            SequentialAnimation on opacity {
                running: state === "processing"
                loops: Animation.Infinite
                NumberAnimation { from: 0.4; to: 1.0; duration: 500 }
                NumberAnimation { from: 1.0; to: 0.4; duration: 500 }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: bridge.start_listening()
        }
    }

    TextField {
        id: textInput
        width: 520
        height: 60
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: "ENTER COMMAND..."
        color: "white"
        font.pixelSize: 18
        background: Rectangle {
            color: "#101a2d"
            radius: 15
            border.color: jarvisBlue
            border.width: 1
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