import QtQuick 2.12
import QtQuick.Window 2.12
import CanDrv 1.0
import DisplayDrv 1.0

Window {
    id: window
    visible: true
//    visibility: "FullScreen"
    width: 800
    height: 480
    color: "#000000"
//    property alias window: window
    title: qsTr("Rennteam 11-14 Display")

/*
//Test
    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: cd.mockCanData()
    }
*/

    CanDrv {
        id: cd
        onNewCanData: dd.setCanData(cd.canData)
    }

    DisplayDrv {
        id: dd
    }

    // TODO: parametrize x/y/h/w dimensions

    // Background picture
    BorderImage {
        id: borderImage
        x: 0
        y: 0
        width: 800
        height: 480
        visible: true
        source: "qrc:/img/carbonfiber_background.png"

        Image {
            id: image
            /*
            x: 375
            y: 380
            width: 50
            height: 50
            */
            /* Temporary position while no gear sensor is available */
            x: 350
            y: 250
            width: 100
            height: 100
            source: "qrc:/img/horse.png"
            fillMode: Image.PreserveAspectFit
        }

        // Circles in the bottom
        Rectangle {
            id: screen1
            x: 350
            y: 440
            width: 20
            height: 20
            color: "#808080"
            radius: 10
        }

        Rectangle {
            id: screen2
            x: 390
            y: 440
            width: 20
            height: 20
            color: "#808080"
            radius: 10
        }

        Rectangle {
            id: screen3
            x: 430
            y: 440
            width: 20
            height: 20
            color: "#808080"
            radius: 10
        }
    }

    // Reference to RevStyle that display the rmp count
    RevStyle {
        id: rev
        width: 800
        height: 200
        currentRev: dd.displayData.rev.toFixed(1)

        minRev: 0
        maxRev: 10000

        numRec: 20
    }

/* Temporarily disabled while no gear sensor is available */
/*
    // Get the gear number
    Text {
        id: gear
        x: 300
        y: 202.5
        color: "#ffffff"
        width: 200
        height: 145
        text: dd.displayData.gear
        //text: qsTr("#dd.displayData.gear#")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        ///wrapMode: Text.NoWrap
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        clip: false
        font.pixelSize: 200
    }
*/

    // Display 1
    Item {
        id: display1
        x: 0
        y: 0
        width: 800
        height: 480
        visible: (dd.displayData.page === 0)

        // Bottom Circle Highlight
        Rectangle {
            id: screen1_check
            x: 350
            y: 440
            width: 20
            height: 20
            color: "#ffffff"
            radius: 10
        }

        // Following graphic is for the left hand side

        Text {
            id: water_temp
            x: 200
            y: 380
            width: 100
            height: 40
            color: "#ffffff"
            text: "Water Tmp"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: oil_temp
            x: 200
            y: 260
            width: 100
            height: 40
            color: "#ffffff"
            text: "Oil Temp"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: oil_pres
            x: 50
            y: 380
            width: 100
            height: 40
            color: "#ffffff"
            text: "Oil Pres"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: fuel_pres
            x: 50
            y: 260
            width: 100
            height: 40
            color: "#ffffff"
            text: "Fuel Pres"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Rectangle {
            color: (dd.displayData.limit[0] === true ? "red" : "transparent")
            x: 200
            y: 320
            width: 120
            height: 60

            Text {
                id: water_temp_data
                color: "#ffffff"
                text: dd.displayData.grid[0].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        Rectangle {
            color: (dd.displayData.limit[1] === true ? "red" : "transparent")
            x: 200
            y: 200
            width: 120
            height: 60

            Text {
                id: oil_temp_data
                color: "#ffffff"
                text: dd.displayData.grid[1].toFixed(1)
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        Rectangle {
            color: (dd.displayData.limit[2] === true ? "red" : "transparent")
            x: 50
            y: 320
            width: 120
            height: 60

            Text {
                id: oil_pres_data
                color: "#ffffff"
                text: dd.displayData.grid[2].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        Rectangle {
            color: (dd.displayData.limit[3] === true ? "red" : "transparent")
            x: 50
            y: 200
            width: 120
            height: 60

            Text {
                id: fuel_pres_data
                color: "#ffffff"
                text: dd.displayData.grid[3].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        // Following graphic is for the right hand side

        Text {
            id: throttle_pos
            x: 650
            y: 380
            width: 100
            height: 40
            color: "#ffffff"
            text: "Throttle"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: rev_count
            x: 650
            y: 260
            width: 100
            height: 40
            color: "#ffffff"
            text: "RPM"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: brake_front
            x: 500
            y: 380
            width: 100
            height: 40
            color: "#ffffff"
            text: "Brake Fr"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Text {
            id: brake_rear
            x: 500
            y: 260
            width: 100
            height: 40
            color: "#ffffff"
            text: "Brake Rear"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            font.pixelSize: 20
        }

        Rectangle {
            color: (dd.displayData.limit[4] === true ? "red" : "transparent")
            x: 650
            y: 320
            width: 120
            height: 60

            Text {
                id: throttle_pos_data
                color: "#ffffff"
                text: dd.displayData.grid[4].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        Rectangle {
            color: (dd.displayData.limit[5] === true ? "red" : "transparent")
            x: 650
            y: 205
            width: 120
            height: 60

            Text {
                id: rev_count_data
                color: "#ffffff"
                text: dd.displayData.grid[5].toFixed(0)
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                font.pixelSize: 50
            }
        }

        Rectangle {
            color: (dd.displayData.limit[6] === true ? "red" : "transparent")
            x: 500
            y: 320
            width: 120
            height: 60

            Text {
                id: brake_front_data
                color: "#ffffff"
                text: dd.displayData.grid[6].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }

        Rectangle {
            color: (dd.displayData.limit[7] === true ? "red" : "transparent")
            x: 500
            y: 200
            width: 120
            height: 60

            Text {
                id: brake_rear_data
                color: "#ffffff"
                text: dd.displayData.grid[7].toFixed(1)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                font.pixelSize: 60
            }
        }
    }
}
