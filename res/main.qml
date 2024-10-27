import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

ApplicationWindow {
    visible: true
    width: 908
    height: 449
    title: "App de Muestra"

    Rectangle{
        id:header
        width: parent.width
        height: 50
        color: "#070F2B"

        Row{
            anchors.verticalCenter: parent.verticalCenter 
            anchors.left: parent.left
            anchors.leftMargin: 30
            spacing: 20
            Image {
                source: "img/makeplaceLogo.png"
                width: 30
                height: 30
            }

            Image {
                source: "img/arrow.png"
                width: 30
                height: 30
            }

            Image {
                source: "img/teamcraftLogo.png"
                width: 30
                height: 30
            }
        }
    }

    Rectangle{
        id: leftBody
        anchors.top: header.bottom
        width: 308
        height: parent.height - header.height
        color: "#070F2B"
        Column{
            anchors.centerIn: parent
            AnimatedImage {
                source: "img/chocobo.gif"
                playing: true
                width: 200
                height: 200
                fillMode: Image.PreserveAspectFit
            }
        }
    }
    Rectangle{
        id: rightBody
        anchors.top: header.bottom
        anchors.left: leftBody.right
        width: parent.width - leftBody.width
        height: parent.height - header.height
        color: "#070F2B"

        Column{
            anchors.centerIn: parent
            spacing: 23
            Rectangle{
                id: searcher
                width: 507
                height: 47
                radius: 10
                color: "#CFCEE5"

                Rectangle{
                    anchors.top: searcher.top
                    anchors.right: searcher.right
                    color: "#535C91"
                    height: parent.height
                    width: 88
                    radius: 10
                }

                TextField {
                    id: filePathField
                    width: parent.width - 88 - 10
                    height: parent.height
                    anchors.top: searcher.top
                    anchors.left: searcher.left
                    anchors.leftMargin: 10
                    placeholderText: "Select a json..."
                    readOnly: false
                    background: null
                    font.pointSize: 14
                }
                Button{
                    anchors.top: searcher.top
                    anchors.left: filePathField.right
                    // color: "#535C91"
                    height: parent.height
                    width: 88-10
                    onClicked: fileDialog.open()
                    background: Rectangle {
                        color: "#535C91"
                    }
                    Text {
                        text: " ..."
                        font.pointSize: 14
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter 
                        anchors.verticalCenter: parent.verticalCenter 
                    }
                }
            }
            Rectangle{
                id: generateButton
                width: 237
                height: 47
                anchors.horizontalCenter: parent.horizontalCenter 
                color: "transparent"
                border.width: 1
                border.color: "white"

                Text{
                    text: " GENERATE!"
                    font.pointSize: 14
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter 
                    anchors.verticalCenter: parent.verticalCenter 
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        var url = filePathField.text;
                        generatorUrl.setFilepath(url)
                    }
                }
            }

            Row{
                spacing: 33
                width: parent.width
                visible: generatorUrl.getIsCharget
                Rectangle{
                    id: urlGarden
                    width: 237
                    height: 47
                    color: "transparent"
                    border.width: 1
                    border.color: "white"

                    Text{
                        text: "Garden"
                        font.pointSize: 14
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter 
                        anchors.verticalCenter: parent.verticalCenter 
                    }

                    MouseArea {
                        id: mouseAreaGarden
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            generatorUrl.generateUrlGarden()
                            snackbar.show("Copied to clipboard!")
                        }
                    }
                }

                Rectangle{
                    id: urlHouse
                    width: 237
                    height: 47
                    color: "transparent"
                    border.width: 1
                    border.color: "white"

                    Text{
                        text: "House"
                        font.pointSize: 14
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter 
                        anchors.verticalCenter: parent.verticalCenter 
                    }

                    MouseArea {
                        id: mouseAreaHouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            generatorUrl.generateUrlInterior()
                            snackbar.show("Copied to clipboard!")
                        }
                    }
                }
            }

            Rectangle{
                id: urlAll
                width: 507
                height: 47
                color: "transparent"
                border.width: 1
                border.color: "white"
                visible: generatorUrl.getIsCharget
                Text{
                    text: "Export All!"
                    font.pointSize: 14
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter 
                    anchors.verticalCenter: parent.verticalCenter 
                }

                MouseArea {
                    id: mouseAreaAll
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        generatorUrl.generateAll()
                        snackbar.show("Copied to clipboard!")
                    }
                }
            }
        }
        FileDialog {
            id: fileDialog
            title: "Select the json"
            onAccepted: {
                var fileUrl = fileDialog.fileUrl.toString(); 
                if (fileUrl.indexOf("file:///") === 0) {
                    fileUrl = fileUrl.substring(8);
                }
                filePathField.text = fileUrl;
            }
            onRejected: console.log("Selección de archivo cancelada")
        }
    }

    Rectangle {
        id: snackbar
        width: parent.width * 0.3
        height: 40
        color: "#535C91"
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        opacity: 0
        anchors.bottom: parent.bottom
        visible: false

        Text {
            id: snackbarText
            text: "Mensaje de Snackbar"
            color: "white"
            anchors.centerIn: parent
        }

        Timer {
            id: hideTimer
            interval: 3000 
            running: false
            onTriggered: snackbar.hide()
        }

        function show(message) {
            snackbarText.text = message
            snackbar.visible = true
            showAnimation.start()
            hideTimer.start()
        }

        function hide() {
            hideAnimation.start()
        }

        PropertyAnimation {
            id: showAnimation
            target: snackbar
            property: "opacity"
            from: 0
            to: 1
            duration: 250
        }

        PropertyAnimation {
            id: hideAnimation
            target: snackbar
            property: "opacity"
            from: 1
            to: 0
            duration: 250
            onStopped: snackbar.visible = false
        }
    }
}