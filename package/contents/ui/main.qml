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
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 350
        Layout.minimumHeight: 700 // COMPACT TWEAK: Shrunk overall window height

        property color rogRedBase: "#E50914"
        property color rogRedGlow: "#FF3333"
        property color textLight: "#FFFFFF"
        property color textDim: "#888888"
        property color borderDim: "#333333"
        property color borderLight: "#4A4A4A"

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

        // --- Styled Components ---

        component ArmouryButton: Controls.Button {
            id: btn
            property string titleText
            property string subText
            property bool isActive: false
            property string customIcon: ""

            Layout.fillWidth: true
            implicitHeight: 62 // COMPACT TWEAK: Shrunk from 62 to 48
            implicitWidth: 100

            background: Rectangle {
                radius: 6
                border.color: btn.isActive ? rogRedGlow : borderDim
                border.width: btn.isActive ? 2 : 1

                gradient: Gradient {
                    GradientStop { position: 0.0; color: btn.isActive ? "#4A0F14" : "#222222" }
                    GradientStop { position: 1.0; color: btn.isActive ? "#220508" : "#151515" }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: "white"
                    opacity: btn.hovered ? 0.05 : 0
                }
            }

            contentItem: ColumnLayout {
                spacing: 0
                anchors.centerIn: parent

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 6
                    Image {
                        source: btn.customIcon
                        visible: btn.customIcon !== ""
                        Layout.preferredWidth: 22 // COMPACT TWEAK: slightly smaller icon
                        Layout.preferredHeight: 22
                        fillMode: Image.PreserveAspectFit
                        opacity: btn.isActive ? 1.0 : 0.6
                    }
                    Text {
                        text: btn.titleText
                        color: btn.isActive ? textLight : "#CCCCCC"
                        font.pixelSize: 16 // COMPACT TWEAK: Shrunk by 1pt
                        font.bold: btn.isActive
                    }
                }
                Text {
                    text: btn.subText
                    color: btn.isActive ? textLight : textDim
                    font.pixelSize: 12 // COMPACT TWEAK: Shrunk by 1pt
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -12
                    Layout.bottomMargin: 3
                    visible: btn.subText !== ""
                }
            }
        }

        component SectionHeader: RowLayout {
            property string title
            property string iconSource
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 14 // COMPACT TWEAK: Less gap above headers

            Image {
                source: iconSource
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                fillMode: Image.PreserveAspectFit
            }
            Text {
                text: title
                color: textLight
                font.pixelSize: 20 // COMPACT TWEAK: Slightly smaller header
                font.bold: true
            }
        }

        component StatusRow: Rectangle {
            property string label
            property string value

            Layout.fillWidth: true
            height: 40 // COMPACT TWEAK: Shrunk from 40 to 34
            radius: 6
            border.color: borderDim
            border.width: 1
            Layout.topMargin: 5

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#111111" }
                GradientStop { position: 1.0; color: "#0A0A0A" }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Text {
                    text: label
                    color: textDim
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }
                Text {
                    text: value
                    color: rogRedGlow
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        // --- Main Widget Container ---
        Rectangle {
            anchors.fill: parent
            radius: 12
            border.color: borderLight
            border.width: 1

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2B2B2B" }
                GradientStop { position: 0.2; color: "#1E1E1E" }
                GradientStop { position: 1.0; color: "#111111" }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16 // COMPACT TWEAK: Tighter outer padding
                spacing: 8 // COMPACT TWEAK: Tighter spacing between elements

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Image {
                        source: "../../assets/rog.png"
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: "ARMOURY Plasmoid"
                        font.pixelSize: 26 // COMPACT TWEAK: Slightly smaller title
                        font.bold: true
                        color: textLight
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: borderDim
                    Layout.topMargin: 2
                }

                // Performance Mode
                SectionHeader { title: "Performance Mode"; iconSource: "../../assets/performance.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
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

                // GPU Mode
                SectionHeader { title: "GPU Mode"; iconSource: "../../assets/gpu.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
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

                // Fan Control
                SectionHeader { title: "Fan Control"; iconSource: "../../assets/fan.png" }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    ArmouryButton {
                        titleText: "Auto"; subText: ""
                        customIcon: "../../assets/rog.png"
                        isActive: backend.currentFanMode === "Auto"
                        onClicked: backend.setFanMode("Auto")
                    }
                    //ArmouryButton {
                    //    titleText: "Max"; subText: ""
                    //    customIcon: "../../assets/rog.png"
                    //    isActive: backend.currentFanMode === "Max"
                    //    onClicked: backend.setFanMode("Max")
                    //}
                }

                Item { Layout.fillHeight: true } // Fills empty space

                // Footer
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: borderDim
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 2
                    Text {
                        text: "Current version 1.0"
                        color: textDim
                        font.pixelSize: 11
                        Layout.fillWidth: true
                    }
                    Controls.Button {
                        icon.name: "view-refresh"
                        flat: true
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        onClicked: {
                            backend.refreshStatus()
                            root.secondsAgo = 0
                        }
                        background: Rectangle {
                            color: "transparent"
                            radius: 14
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "white"
                                opacity: parent.parent.hovered ? 0.08 : 0
                            }
                        }
                    }
                }
            }
        }
    }
}
