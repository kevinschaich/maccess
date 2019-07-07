# Maccess

**Maccess (Mac-Access)** aims to provide easy access your home network, Mac, and files remotely using DDNS, OpenVPN, SMB, and VNC.

With Apple announcing the sunset of both MacOS Server and Back to My Mac, there are limited full-circle options to access your home computer and network. Maccess provides a complete guide on setting up all the components necessary so that you can access your home network via VPN from anywhere, as well as all its devices, how to access your computer remotely via VNC, how to access your files via SMB.

This guide should be compatible with all recent versions of MacOS, including Yosemite, El Capitan, Sierra, High Sierra, Mojave and Catalina. In each section, we'll try to provide some primer for the technology we'll be using, and (where possible) automate steps via one-click scripts.

#### Why would I want to do this?

* Remotely access your home computer
* Safely access your home network and encrypt traffic from public Wi-fi points such as coffee shops
* Access your home devices like printers, scanners, media servers, smart home devices, and NAS devices
* It's free, open-source, and self-hosted

## Part 1: Housekeeping

#### Primer

Maccess works best when you have an always-on, desktop Mac at home. You can use an old laptop but be aware that leaving a laptop plugged in can dramatically shorten its battery/component lifespan due to insufficient cooling.

We'll call your always-on desktop Mac the **server**, and we'll call the devices you want to use for remote access the **clients**.

For the purposes of this guide, we'll assume you have:

* A Mac
  * Desktop (iMac, Mac Mini, iMac Pro, or Mac Pro) highly recommended
  * Always connected to power & turned on
  * Modern specs with a dual-core processor and at least 8GB of memory
  * Running OS X Yosemite or later
* Time & Patience

#### Guide

Run these commands to install everything you need for Part 1:

```bash
# Install MacOS Developer Tools (including Git)
xcode-select --install

# Install Homebrew (https://brew.sh)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Navigate to your home directory:
cd ~

# Clone this repo:
git clone https://github.com/kevinschaich/maccess.git

# Make the scripts executable so you can run them in your terminal:
chmod u+x ./scripts/*
```

## Part 2: Set up Dynamic DNS (DDNS) access for your Mac

#### Primer

TODO

#### Guide

TODO

## Part 3: Set up remote access to your home network using OpenVPN

#### Primer

TODO

#### Guide

1. Copy all the files from the `defaults` folder into a `config` folder (ignored from version control):
    
    ```bash
    # Navigate to repo root in your terminal
    cd ~/maccess

    # Create a local copy for your configuration files
    cp -R defaults config
    ```

1. Find the following lines in `config/vars` and edit them if desired:
    
    ```bash
    set_var EASYRSA_REQ_COUNTRY     "US"
    set_var EASYRSA_REQ_PROVINCE    "California"
    set_var EASYRSA_REQ_CITY        "San Francisco"
    set_var EASYRSA_REQ_ORG         "Example Company"
    set_var EASYRSA_REQ_EMAIL       "me@example.net"
    set_var EASYRSA_REQ_OU          "My Organizational Unit"
    ```

1. Find the following line in `config/client.conf` and change `my-server-1` to your Server's IP Address:
    
    ```bash
    remote my-server-1 1194
    ```

1. Run `openvpn.sh`, providing an argument for each client you want to access:

    ```bash
    ./scripts/openvpn.sh Sams-MacBook-Pro Sams-iPhone-8 Katys-iPhone-XS 
    ```

1. Open the newly installed **Tunnelblick** app in your **Applications** folder. Click through the intro prompts, choosing **I have configuration files** when asked.

1. Click the **Tunnelblick Menu Bar Icon** (doorway) and choose **VPN Details...**. Drag `config/server.conf` into the sidebar of the **Configuration** tab.

1. Click **Connect** and give it a few moments. If your server startup was successful, you should see a line somewhere in the logs which contains:

    ```
    Initialization Sequence Completed
    ```

    > If you get any popups that say `The IP address of this machine has not changed` or similar, that's OK, we aren't expecting it to change since it's the server. 

1. Securely transfer the `clients/*.ovpn` files to your respective clients. Recommend using a USB Drive or AirDrop – **do NOT** use email or web services like Dropbox.

1. Install the respective OpenVPN Connect app (**[iOS](https://apps.apple.com/us/app/openvpn-connect/id590379981)**, **[Android](https://play.google.com/store/apps/details?id=net.openvpn.openvpn&hl=en_US)**, **[Windows](https://openvpn.net/vpn-server-resources/connecting-to-access-server-with-windows/#future-replacement-for-openvpn-connect-client)**, or **[Mac](https://openvpn.net/vpn-server-resources/connecting-to-access-server-with-macos/#future-replacement-for-openvpn-connect-client)**) for each client device.

1. Open the the respective `.ovpn` file. Click **Connect.**

## Part 4: Remotely access your Mac desktop using VNC

#### Primer

TODO

#### Guide

TODO

## Part 5: Set up remote file access using SMB

#### Primer

TODO

#### Guide

TODO

## Resources, Further Reading, and Prior art:

* https://github.com/Nyr/openvpn-install/blob/master/openvpn-install.sh
* https://remonpel.nl/2012/02/set-up-an-openvpn-server-on-your-mac/
* https://openvpn.net/community-resources/how-to/#setting-up-your-own-certificate-authority-ca-and-generating-certificates-and-keys-for-an-openvpn-server-and-multiple-clients
