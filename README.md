# volumio-diy
DIY Audio Player project based on Raspberry PI and Volumio.

What I wanted to achieve:
 * Easy handling
 * Good audio playback
 * Great Kid Acceptance Factor (because this thing is going to be placed in our kids’ room)

Why I decided to make, not buy:
 * Operating without smartphone or tablet is mandatory
 * Fun

Features:
 * Play music stored on Audio Player
 * Play music stored on Network Attached Storage
 * Web Radio playback
 * Playback control using RFID tags
 * ...

The player consists of these components:
 * Raspberry PI 3
 * Raspberry PI Touch Display
 * Adafruit Stereo Audio Amplifier
 * USB-DAC
 * USB-RFID Reader
 * External power supply unit (PSU)
 * Internal voltage regulator module (VRM)
 * Mass separation filter (ground loop isolator)

## Step-by-Step Software Installation

 1. Flash Volumio to SD Card
   * Version 2.041: http://updates.volumio.org/pi/volumio/2.041/volumio-2.041-2016-12-12-pi.img.zip
 1. Prepare Volumio
   * Insert SD Card into Raspberry PI
   * Attach Ethernet to Raspberry PI
   * Power on
   * Open Volumio using Webbrowser
     * ```http://volumio.local/```
   * Configure WLAN
 1. Install Software
   * Connect to Volumio using SSH
     * ```ssh -l volumino volumio.local```
   * [Install System](#install-system)
   * [Install LXDE](#install-lxde)
   * [Install Chromium](#install-chromium)
   * [Install unclutter](#install-unclutter)
   * [Install volumio-hid](#install-volumio-hid)
   * [Configure System](#configure-system)
   * Reboot system
     * ```reboot```
 1. Configure Kiosk mode
   * [Configure Desktop](#configure-desktop)
   * [Configure Autostart](#configure-desktop)
   * Reboot system
     * ```reboot```
 1. [Configure RFID playback control](#configure-rfid-playback-control)

### Install System

Update current system:
```
# apt-get update
# apt-get upgrade
# apt-get install apt-show-versions
# apt-show-versions -u
# apt-get dist-upgrade
```
Install essential tools:
```
# apt-get install screen less vim
# apt-get install build-essential
```

### Install LXDE

*LXDE is a desktop environment build upon the X Window System. This uses LightDM as X display manager. LXDE will be used to run a web browser to present the user interface of Volumio in Kiosk mode.*

Install xserver, lxde, lightdm:
```
# apt-get install --no-install-recommends xserver-xorg xutils
# apt-get install lxde-core lxappearance
# apt-get install lightdm
```

Configure display manager to autologin:
```
# vim /etc/lightdm/lightdm.conf
    autologin-user=volumio
```

### Install Chromium

*Chromium is a web browser. Chromium will be used to present the user interface of Volumio in Kiosk mode.*

This installs prebuild packages for Chromium browser on Raspbian.

Get software packages:
```
$ wget http://launchpadlibrarian.net/234969703/chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
$ wget http://launchpadlibrarian.net/234969705/chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
```

Install:
```
# apt-get install libnss3 # Network Security Service
# apt-get install libnspr4 # Portable NetScape Runtime
# dpkg -i chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
# dpkg -i chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
# apt-get install -y -f
# dpkg -i chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
# dpkg -i chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
```

### Install unclutter

*unclutter is a utility to hide the mouse cursor (which is not needed for the touch display). unclutter-fixes is a rewrite of the original unclutter.*

This installs unclutter-fixes build from source.

Prepare for build:
```
# apt-get install libx11-dev libxi-dev libev-dev
```

Clone unclutter-fixes:
```
$ git clone https://github.com/Airblader/unclutter-xfixes
$ cd unclutter-fixes
```

Build unclutter-fixes:
```
$ make
```

Install unclutter-fixes:
```
# make install
```

### Install volumio-hid

*volumio-hid is a python script for integration of the rfid reader with Volumio.*

Install Python 3:
```
# apt-get install python3
# easy_install3 pip
```

Install script dependencies:
```
# pip3 install evdev
# pip3 install pyyaml
# pip3 install socketIO-client
```

Clone volumio-hid:
```
$ git clone https://github.com/edmw/volumio-hid.git
```

### Configure System

```
# vim /config.txt
    gpu_mem=128
```

TODO

## Configure Kiosk mode

### Configure Desktop

 1. Boot into desktop environment
 1. Change settings:
   * Set desktop background to black
   * Hide traschcan icon

### Configure Autostart

```
# vim ~/.config/lxsession/LXDE/autostart
    @unclutter --timeout 0
    @chromium-browser --kiosk --no-first-run --noerrdialogs --enable-touch-events --disable-touch-editing --disable-3d-apis --disable-breakpad --disable-crash-reporter --disable-infobars --disable-session-crashed-bubble --disable-translate http://localhost:3000/
```

## Configure RFID playback control

RFID playback control works with RFID readers which present themselves as USB HID keyboard device. That is, it just types out the characters it reads.

volumio-hid uses a configuration which has to be adapted for the specific RFID reader and the specific RFID tags used.

 1. Connect USB-RFID reader
 1. Find the correct device file for the reader
   * ```/dev/input/by-id/usb-13ba_Barcode_Reader-event-kbd```

TODO
