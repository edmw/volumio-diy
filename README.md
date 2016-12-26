[[Software Installation](#step-by-step-software-installation)]&nbsp;|
[[Configure Kiosk mode](#configure-kiosk-mode)]&nbsp;|
[[Configure RFID playback control](#configure-rfid-playback-control)]&nbsp;|
[[Parts & Links](#appendix-a---parts-list-and-links)]&nbsp;|

# volumio-diy

DIY Audio Player project based on Raspberry Pi and Volumio.

![DIY](https://github.com/edmw/volumio-diy/raw/master/FILES/DIY-1.jpg)

What I wanted to achieve:
 * Easy handling
 * Good audio playback
 * Great Kid Acceptance Factor (because this thing is going to be placed in our kids’ room)

Why I decided to make, not buy:
 * Operating without smartphone or tablet is mandatory
 * Fun

![DIY](https://github.com/edmw/volumio-diy/raw/master/FILES/DIY-2.jpg)

Features:
 * Play music stored on Audio Player
 * Play music stored on Network Attached Storage
 * Web Radio playback
 * Playback control using RFID tags
 * ...

The player consists of these [components](#appendix-a-components):
 * Raspberry Pi 3
 * Raspberry Pi Touch Display
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
   * Attach Ethernet to Raspberry Pi
   * Insert SD Card into Raspberry Pi
   * Power on
   * Open Volumio using Webbrowser
     * ```http://volumio.local/```
   * Configure Network/WLAN
   * Configure Playback/Output
     * Select 'USB: Codec'
 1. Install Software
   * Connect to Volumio using SSH
     * ```ssh -l volumino volumio.local```
   * [Install System](#install-system)
   * [Install LXDE](#install-lxde)
   * [Install Chromium](#install-chromium)
   * [Install unclutter](#install-unclutter)
   * [Install volumio-hid](#install-volumio-hid)
   * [Install volumio-diy](#install-volumio-diy)
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

`root@volumio.local:~#`
```
apt-get update
apt-get upgrade
apt-get install apt-show-versions
apt-show-versions -u
apt-get dist-upgrade
```

Install essential tools:

`root@volumio.local:~#`
```
apt-get install man less vim screen
```

Install additional locales:

`root@volumio.local:~#`
```
apt-get install locales
dpkg-reconfigure locales
```

Install packages needed to build from source:

`root@volumio.local:~#`
```
apt-get install build-essential
apt-get install libx11-dev libxi-dev libev-dev
apt-get install --no-install-recommends asciidoc libxml2-utils xsltproc docbook-xsl
```

Optional: Install bluetooth:

`root@volumio.local:~#`
```
apt-get install raspberrypi-sys-mods
apt-get install pi-bluetooth
```

### Install LXDE

*LXDE is a desktop environment build upon the X Window System. This uses LightDM as X display manager. LXDE will be used to run a web browser to present the user interface of Volumio in Kiosk mode.*

Install xserver, lxde, lightdm:

`root@volumio.local:~#`
```
apt-get install --no-install-recommends xserver-xorg xutils
apt-get install --no-install-recommends lxde-core lxappearance
apt-get install --no-install-recommends lightdm
```

Configure display manager to autologin:

`root@volumio.local:~#`
```
vim /etc/lightdm/lightdm.conf
```
```
autologin-user=volumio
```

### Install Chromium

*Chromium is a web browser. Chromium will be used to present the user interface of Volumio in Kiosk mode.*

Add Raspberry Pi Foundation APT repository for Raspbian:

`root@volumio.local:~#`
```
vim /etc/apt/sources.list
```
```
deb http://archive.raspberrypi.org/debian/ jessie main
deb-src http://archive.raspberrypi.org/debian/ jessie main
```

`root@volumio.local:~#`
```
wget http://archive.raspberrypi.org/debian/raspberrypi.gpg.key -O - | sudo apt-key add -
```

Install chromium-browser:

`root@volumio.local:~#`
```
apt-get update
apt-get install --no-install-recommends chromium-browser
```

### Install unclutter

*unclutter is a utility to hide the mouse cursor (which is not needed for the touch display). unclutter-fixes is a rewrite of the original unclutter.*

This installs unclutter-fixes build from source.

Clone unclutter-fixes:

`root@volumio.local:~#`
```
git clone https://github.com/Airblader/unclutter-xfixes
```

Install unclutter-fixes:

`root@volumio.local:~/unclutter-fixes#`
```
make
make install
```

### Install volumio-hid

*volumio-hid is a python script for integration of the rfid reader with Volumio.*

Install Python 3:

`root@volumio.local:~#`
```
apt-get install python3 python3-setuptools python3-venv python3-dev
easy_install3 pip
```

Create virtual environment for volumio-hid:

`volumio@volumio.local:~$`
```
mkdir /home/volumio/.pyenv
python3 -m venv /home/volumio/.pyenv/volumio-hid
source /home/volumio/.pyenv/volumio-hid/bin/activate
pip3 install evdev
pip3 install pyyaml
pip3 install socketIO-client
```

Clone volumio-hid:

`volumio@volumio.local:~$`
```
git clone https://github.com/edmw/volumio-hid.git
```

### Install volumio-diy

*volumio-diy is this documentation and a set of configuration files to run this audio player.*

Clone volumio-diy:

`root@volumio.local:~#`
```
git clone https://github.com/edmw/volumio-diy.git
```

### Configure System

`root@volumio.local:~#`
```
vim /boot/config.txt
```
```
gpu_mem=128
```

## Configure Kiosk mode

### Configure Desktop

NOOP

### Configure Autostart

This sets the screensaver to turn off the display after 5 minutes, disables the desktop panel and the file manager application, starts unclutter to hide the mouse cursor and, finally, starts the web browser in kiosk mode.

`volumio@volumio.local:~$`
```
vim ~/.config/lxsession/LXDE/autostart
```
```
xset s blank
xset s 300
xset dpms 0 300 300
#@lxpanel --profile LXDE
#@pcmanfm --desktop --profile LXDE
@unclutter --timeout 0
@chromium-browser --kiosk --no-first-run --noerrdialogs --enable-touch-events --disable-touch-editing --disable-3d-apis --disable-breakpad --disable-crash-reporter --disable-infobars --disable-session-crashed-bubble --disable-translate http://localhost:3000/
```

## Configure RFID playback control

RFID playback control works with RFID readers which present themselves as USB HID keyboard device. That is, it just types out the characters it reads.

volumio-hid uses a configuration which has to be adapted for the specific RFID reader and the specific RFID tags used.

 1. Connect USB-RFID reader
 1. Find the correct device file for the reader
   * ```/dev/input/by-id/usb-13ba_Barcode_Reader-event-kbd```

```
$ sudo usermod -a -G input volumio
$ sudo chmod 664 /lib/systemd/system/volumio-hid.service
$ sudo systemctl daemon-reload
$ sudo systemctl enable volumio-hid.service
$ sudo systemctl start volumio-hid.service
```

FIXME

# Appendix A - Parts list and Links

*List of used parts*

 * Raspberry Pi 3 Model B
  * https://www.raspberrypi.org/products/raspberry-pi-3-model-b/
 * Raspberry Pi Touch Display
  * https://www.raspberrypi.org/products/raspberry-pi-touch-display/
 * Behringer U-Control UCA222 USB Audio Interface
  * https://www.amazon.com/dp/B0023BYDHK/
 * Adafruit Stereo 20W Class D Audio Amplifier
  * https://www.adafruit.com/products/1752
 * PAC SNI-1/3.5 Ground Loop Noise Isolator
  * https://www.amazon.com/dp/B001EAQTRI/
 * RFID Card Reader and Cards
  * https://www.amazon.de/gp/product/B00HSDOTTU
  * https://www.amazon.de/gp/product/B00REFN24A
 * Toggle Switch and Missile Switch Cover
  * https://www.sparkfun.com/products/9276
  * https://www.sparkfun.com/products/9278
 * Speaker Connector
  * http://www.dynavox-audio.de/Zubehoer/::108.html
 * Cables
  * USB2.0 Typ micro (Power for Raspberry Pi)  
  * USB2.0 Typ micro (Power for Raspberry Touch Display)
 * FIXME: 80W AC Adapter
 * FIXME: 80W DC-DC Converter
