# ASUS Armoury KDE Plasmoid (`org.kde.armoryplasmoid`)

<img width="560" height="621" alt="image" src="https://github.com/user-attachments/assets/ac4936d8-52af-4f3f-a848-7bb85558867c" />

`


An Armoury Crate-style native KDE Plasma 6 widget designed for ASUS laptops running Linux. It provides quick access to hardware performance modes, GPU multiplexer switching, and fan profiles, styled with a dark ROG aesthetic and dynamic accent matching.



---

## Features

* **Performance Profiles**: Seamlessly switch between Silent (Quiet), Balanced, and Turbo (Performance) modes via `asusctl`.
* **GPU Mode Switching**: Control hybrid graphics configurations (Hybrid/MUX, Integrated iGPU, Dedicated NVIDIA) via `supergfxctl`.
* **Fan Control**: Toggle fan profiles (Auto / Max).
* **Live Status Tracking**: Auto-refreshes state and updates active highlights.
* **Versatile Placement**: Works natively both as a desktop widget and directly on the taskbar panel with a dedicated ROG panel icon.

### Currently working
* Performance modes
* GPU modes
* Live status

### TODO
* Fan control as Auto and MAX 2 different modes
* Some simple AURA lightning controls; brightness, aura modes
* Battery charge limitter with 4 modes (20%, 60%, 80%, 100%)

---

## Dependencies & Prerequisites

To build and run this plasmoid from source, ensure you have the following system utilities and development packages installed:

### System Tools
* [`asusctl`](https://gitlab.com/asus-linux/asusctl) (running and active on your system)
* [`supergfxctl`](https://gitlab.com/asus-linux/supergfxctl) (for GPU switching)

#### Build & Development Packages ((K)Ubuntu / Debian)
```bash
sudo apt install extra-cmake-modules qt6-base-dev qt6-declarative-dev libplasma-dev libkf6i18n-dev build-essential cmake
```
#### Clone the repository
```bash
git clone https://github.com/furkanzdm/armoryplasmoid.git
cd asus-armory-plasmoid
```
#### Create build directory and compile
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
```

#### Generate a Debian package via CPack and install through APT
```bash
cpack -G DEB
sudo apt install ./asus-armoury-plasmoid-1.0-Linux.deb
```
#### OR install it directy by make
```bash
sudo make install
```
