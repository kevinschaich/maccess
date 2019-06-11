# Maccess

**Maccess (Mac-Access)** aims to provide easy access your home network, Mac, and files remotely using DDNS, OpenVPN, SMB, and VNC.

With Apple announcing the sunset of both MacOS Server and Back to My Mac, there are limited full-circle options to access your home computer and network. Maccess provides a complete guide on setting up all the components necessary so that you can access your home network via VPN from anywhere, as well as all its devices, how to access your computer remotely via VNC, how to access your files via SMB.

This guide should be compatible with all recent versions of MacOS, including Yosemite, El Capitan, Sierra, High Sierra, Mojave and Catalina. In each section, we'll try to provide some primer for the technology we'll be using, a manual walkthrough of how to set it up, and (where possible) automate steps via one-click scripts.

#### Why would I want to do this?

* Remotely access your home computer
* Safely access your home network and encrypt traffic from public Wi-fi points such as coffee shops
* Access your home devices like printers, scanners, media servers, smart home devices, and NAS devices
* It's free, open-source, and self-hosted

## Part 1: Housekeeping

Maccess works best when you have an always-on, desktop Mac at home. You can use an old laptop but be aware that leaving a laptop plugged in can dramatically shorten its battery/component lifespan due to insufficient cooling.

#### Prerequisites

For the purposes of this guide, we'll assume you have:

* A Mac
  * Always connected to power & turned on
  * Decently spec'd with a dual-core processor and at least 8GB of memory
  * Running OS X Yosemite or later
* Time & Patience

You'll also need:

* [Git](https://git-scm.com/) installed – you can do this by running `xcode-select --install`
* [Homebrew](https://brew.sh/) – follow instructions on that page to install

## Part 2: Set up Dynamic DNS (DDNS) access for your Mac

### Primer

TODO

### The Easy Way
 
TODO

### The Hard Way

TODO

## Part 3: Set up remote access to your home network using OpenVPN

### Primer

TODO

### The Easy Way

You'll need [Homebrew](https://brew.sh) installed.

```
brew cask install tunnelblick
git clone https://github.com/kevinschaich/maccess
cd maccess
chmod u+x ./scripts/openvpn.sh
./scripts/openvpn.sh
```

### The Hard Way

Fine, have it your way.

We have [a guide detailing how to set up OpenVPN from scratch](./docs/OpenVPN.md).

## Part 4: Remotely access your Mac desktop using VNC

### Primer

TODO

### The Easy Way
 
TODO

### The Hard Way

TODO


## Part 5: Set up remote file access using SMB

### Primer

TODO

### The Easy Way
 
TODO

### The Hard Way

TODO

## Resources, Further Reading, and Prior art:

* https://github.com/Nyr/openvpn-install/blob/master/openvpn-install.sh
* https://remonpel.nl/2012/02/set-up-an-openvpn-server-on-your-mac/
* https://openvpn.net/community-resources/how-to/#setting-up-your-own-certificate-authority-ca-and-generating-certificates-and-keys-for-an-openvpn-server-and-multiple-clients
