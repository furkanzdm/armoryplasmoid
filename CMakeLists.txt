cmake_minimum_required(VERSION 3.16)
project(AsusArmouryPlasmoid)

# Tell CMake to automatically run Qt's MOC (Meta-Object Compiler)
set(CMAKE_AUTOMOC ON)

find_package(ECM 6.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)
find_package(Plasma REQUIRED) 
find_package(KF6 REQUIRED COMPONENTS I18n)

# Build the C++ backend plugin
add_library(asusarmouryplugin SHARED 
    src/plugin.cpp 
    src/asusbackend.cpp
)
target_link_libraries(asusarmouryplugin Qt6::Core Qt6::Qml)

# Install the QML package and the plugin
plasma_install_package(package org.kde.armoryplasmoid)
install(TARGETS asusarmouryplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/armoryplasmoid)
install(FILES src/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/armoryplasmoid)

# --- CPack Configuration for Debian Package ---
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_NAME "asus-armoury-plasmoid")
set(CPACK_PACKAGE_VERSION "1.0")
set(CPACK_PACKAGE_CONTACT "furkanzdm@github <contact@mail.me>")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ASUS Armoury Crate-Style KDE Plasmoid")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")

# This must be the absolute last line in the file
include(CPack)
