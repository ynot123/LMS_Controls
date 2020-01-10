## Hass.io or Home Assistant Installation

## Multiple Platforms - PI, PI-OSMC, Debian

------

The following document outlines the steps required to install and configure HassIO or Home Assistant on multiple platforms including stand-alone Raspberry PI, PI with OSMC and Intel / AMD with Debian.

The preferred software distribution is Hass.io as it is a combination of Home Assistant and assorted tools which allows you to run it easily on a Raspberry Pi and other platforms.  In addition Hass.io also allows the installation of a large assortment of add-ons (Configurator, DuckDNS, Let's Encrypt) in a easy to configure method for Home Assistant.

The current list of Hass.io or Home Assistant installation platforms covered by this document are:

- Hass.io stand alone with Raspberry PI series
- Hass.io on Raspberry PI running OSMC (kodi) image.
- Hass.io on generic Debian server or even Desktop I suppose 

Any users who are willing to take the time to detail their installation process for Hass.io or Home Assistant on their platform are welcome to submit their instructions and I will include them here.  This software can be installed on most systems with a bit of tweaking.

Before we go too far, here is a list of resources that can help with the installation on other platforms which may not have been detailed here. 

- Hass.io general install information all platforms:  https://www.home-assistant.io/hassio/installation/
- Home Assistant package for Synology NAS:  
- Home Assistant for QNAS:  



#### Hass.io - Stand-Alone Raspberry PI Installation Instructions

The following instructions will go through the basic installation of **Hass.io** on a stand-alone Raspberry PI using a pre-configured image.  It makes use of DuckDNS / Lets encrypt add-ons to allow outside access over the internet to your Hass.io installation.  

1. Download a copy of Hass.io install image for your Raspberry PI from here:  https://www.home-assistant.io/hassio/installation/

2. Install image writing tool Etcher from here:  https://www.balena.io/etcher/ and write the image file to your SD card (32GB or larger recommended)

3. Install and boot PI and let it do it's thing (updates, install, etc..) for up to 20 minutes.  You can monitor progress of the installation using the PI's IP address link http://xxx.xxx.xxx.xxx:8123.  It can take 10 minutes before this link is available.

4. Once installation completes, you will see the Home Assistant logo and be prompted for your name, username and password.  Enter these, and press **Create Account**.

5. Login using the previous username and password

6. Continue installation by following the Installation Instructions starting from Section B, Step 6.  

   


#### Hass.io Installation on Raspberry PI OSMC Image

The following instructions will go through the basic installation of **Hass.io** on a existing image of OSMC on a Raspberry PI. It makes use of DuckDNS / Lets encrypt add-ons to allow outside access over the internet to your Hass.io installation.  

For more information on this installation visit   https://www.home-assistant.io/hassio/installation/ and review the **Alternative: install on generic Linux server** section.

1. Using Putty, telnet into the Raspberry PI using the root username and password.  The default is: osmc osmc.
2. Run the following commands to install the tools required including docker-ce.
```
sudo -i
apt-get update
apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat software-properties-common
curl -fsSL get.docker.com | sh
```

3. To install Hass.io from the website:  https://github.com/home-assistant/hassio-build/tree/master/install. Run the following command:

```
curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-build/master/install/hassio_install" | bash -s -- -m raspberrypi3
```
4. Wait about 20 minutes for the setup to complete.  You can monitor progress of the installation using the PI's IP address link http://xxx.xxx.xxx.xxx:8123.  It can take 10 minutes before this link is available.
5. Once installation completes, you will see the Home Assistant logo and be prompted for your name, username and password.  Enter these, and press **Create Account**.
6. Continue installation by following the Installation Instructions starting from Section B, Step 6.  



#### Hass.io Installation on a Generic Debian / Ubuntu Server

The following instructions will go through the basic installation of **Hass.io** on a existing Debian server. It makes use of DuckDNS / Lets encrypt add-ons to allow outside access over the internet to your Hass.io installation.  

For more information on this installation visit   https://www.home-assistant.io/hassio/installation/ and review the **Alternative: install on generic Linux server** section.

1. Using Putty, telnet into the Debian server using the root username and password.  
2. Run the following commands to install the tools required including docker-ce.

```
sudo -i
apt-get update
apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat software-properties-common
curl -fsSL get.docker.com | sh
```
3. To install Hass.io, run the following command:

```
curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-build/master/install/hassio_install" | bash -s -m qemux86-64
```
4. Wait up to 20 minutes for the setup to complete.  You can monitor progress of the installation using the servers IP address link http://xxx.xxx.xxx.xxx:8123.  It can take 10 minutes before this link is available.
5. Once installation completes, you will see the Home Assistant logo and be prompted for your name, username and password.  Enter these, and press **Create Account**.
6. Continue installation by following the Installation Instructions starting from Section B, Step 6.

