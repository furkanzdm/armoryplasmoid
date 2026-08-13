import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.armoryplasmoid 1.0

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }

        RowLayout {
            anchors.centerIn: parent
            Image {
                source: "../../assets/rog.png"
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 360
        Layout.minimumHeight: 620

        property color rogRed: "#E50914"
        property color bgDark: "#0A0A0A"
        property color cardBg: "#141414"
        property color textLight: "#EDEDED"
        property color textDim: "#7A7A7A"
        property color borderDark: "#2A2A2A"

        AsusBackend { id: backend }

        Timer {
            interval: 4000
            running: root.expanded
            repeat: true
            onTriggered: backend.refreshStatus()
        }

        Timer {
            interval: 1000
            running: root.expanded
            repeat: true
            onTriggered: root.secondsAgo = backend.secondsSinceUpdate()
        }
        property int secondsAgo: 0

        component ArmouryButton: Controls.Button {
            id: btn
            property string titleText
            property string subText
            property bool isActive: false
            property string customIcon: ""

            Layout.fillWidth: true
            implicitHeight: 60

            background: Rectangle {
                color: btn.isActive ? "#2A0B0E" : cardBg
                border.color: btn.isActive ? rogRed : borderDark
                border.width: 1
                radius: 6

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: "white"
                    opacity: btn.hovered ? 0.05 : 0
                }
            }

            contentItem: ColumnLayout {
                spacing: 2
                anchors.centerIn: parent

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 6
                    Image {
                        source: btn.customIcon
                        visible: btn.customIcon !== ""
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: btn.titleText
                        color: textLight
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
                Text {
                    text: btn.subText
                    color: btn.isActive ? textLight : textDim
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignHCenter
                    visible: btn.subText !== ""
                }
            }
        }

        // FIXED: Replaced Kirigami.Icon with a standard Image component to properly load local assets
        component SectionHeader: RowLayout {
            property string title
            property string iconSource
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 15

            Image {
                source: iconSource
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                fillMode: Image.PreserveAspectFit
            }
            Text {
                text: title
                color: textLight
                font.pixelSize: 14
            }
        }

        component StatusRow: Rectangle {
            property string label
            property string value

            Layout.fillWidth: true
            height: 38
            color: "transparent"
            border.color: borderDark
            border.width: 1
            radius: 6
            Layout.topMargin: 5

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15

                Text {
                    text: label
                    color: textDim
                    font.pixelSize: 13
                    Layout.fillWidth: true
                }
                Text {
                    text: value
                    color: rogRed
                    font.pixelSize: 13
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: bgDark
            radius: 10
            border.color: borderDark
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Image {
                        source: "../../assets/rog.png"
                        Layout.preferredWidth: 22
                        Layout.preferredHeight: 22
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: "ASUS Armoury"
                        font.pixelSize: 18
                        color: textLight
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: borderDark
                    Layout.topMargin: 5
                }

                SectionHeader { title: "Performance Mode"; iconSource: "../../assets/performance.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    ArmouryButton {
                        titleText: "Silent"; subText: "Quiet"
                        isActive: backend.currentPerformanceMode === "Quiet"
                        onClicked: backend.setPerformanceMode("Quiet")
                    }
                    ArmouryButton {
                        titleText: "Balanced"; subText: "Balanced"
                        isActive: backend.currentPerformanceMode === "Balanced"
                        onClicked: backend.setPerformanceMode("Balanced")
                    }
                    ArmouryButton {
                        titleText: "Turbo"; subText: "Performance"
                        isActive: backend.currentPerformanceMode === "Performance"
                        onClicked: backend.setPerformanceMode("Performance")
                    }
                }
                StatusRow {
                    label: "Current Profile"
                    value: backend.currentPerformanceMode === "Performance" ? "Turbo" : (backend.currentPerformanceMode === "Quiet" ? "Silent" : "Balanced")
                }

                SectionHeader { title: "GPU Mode"; iconSource: "../../assets/gpu.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    ArmouryButton {
                        titleText: "Hybrid"; subText: "MUX"
                        isActive: backend.currentGpuMode === "Hybrid"
                        onClicked: backend.setGpuMode("Hybrid")
                    }
                    ArmouryButton {
                        titleText: "Integrated"; subText: "iGPU"
                        isActive: backend.currentGpuMode === "Integrated"
                        onClicked: backend.setGpuMode("Integrated")
                    }
                    ArmouryButton {
                        titleText: "Dedicated"; subText: "NVIDIA"
                        isActive: backend.currentGpuMode === "Dedicated"
                        onClicked: backend.setGpuMode("Dedicated")
                    }
                }
                StatusRow { label: "Current GPU"; value: backend.currentGpuMode }

                SectionHeader { title: "Fan Control"; iconSource: "../../assets/fan.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    ArmouryButton {
                        titleText: "Auto"; subText: ""
                        customIcon: "../../assets/rog.png"
                        isActive: backend.currentFanMode === "Auto"
                        onClicked: backend.setFanMode("Auto")
                    }
                    ArmouryButton {
                        titleText: "Max"; subText: ""
                        customIcon: "../../assets/rog.png"
                        isActive: backend.currentFanMode === "Max"
                        onClicked: backend.setFanMode("Max")
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: borderDark
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    Text {
                        text: "Updated " + root.secondsAgo + "s ago"
                        color: textDim
                        font.pixelSize: 12
                        Layout.fillWidth: true
                    }
                    Controls.Button {
                        icon.name: "view-refresh"
                        flat: true
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        onClicked: {
                            backend.refreshStatus()
                            root.secondsAgo = 0
                        }
                        background: Item {}
                    }
                }
            }
        }
    }
}
