# Maccess

**Maccess (Mac-Access)** aims to provide easy access your home network, Mac, and files remotely using DDNS, OpenVPN, SMB, and VNC.

With Apple announcing the sunset of both MacOS Server and Back to My Mac, there are limited full-circle options to access your home computer and network. Maccess provides a complete guide on setting up all the components necessary so that you can access your home network via VPN from anywhere, as well as all its devices, how to access your computer remotely via VNC, how to access your files via SMB.

This guide should be compatible with all recent versions of MacOS, including Yosemite, El Capitan, Sierra, High Sierra, Mojave and Catalina. In each section, we'll try to provide some primer for the technology we'll be using, a manual walkthrough of how to set it up, and (where possible) automate steps via one-click scripts.

#### Why would I want to do this?

* Remotely access your home computer
* Safely access your home network and encrypt traffic from public Wi-fi points such as coffee shops
* Access your home devices like printers, scanners, media servers, smart home devices, and NAS devices
* It's free, open-source, and self-hosted

#### Prerequisites:

* A recent-spec Mac running OS X Yosemite or later that is always on
* Time & Patience

## Part 1: Set up Dynamic DNS (DDNS) access for your Mac

### Primer

TODO

## Part 2: Set up remote access to your home network using OpenVPN

### Primer

TODO

### I like to do things the easy way

You'll need [Homebrew](https://brew.sh) installed.

```
brew cask install tunnelblick
git clone https://github.com/kevinschaich/maccess
cd maccess
chmod u+x ./scripts/openvpn.sh
./scripts/openvpn.sh
```

### I enjoy suffering and would like to do all of this manually

Fine, have it your way.

Follow [the OpenVPN docs](./docs/OpenVPN.md)

## Part 3: Remotely access your Mac desktop using VNC

### Primer

## Part 4: Set up remote file access using SMB

### Primer

## Resources, Further Reading, and Prior art:

* https://github.com/Nyr/openvpn-install/blob/master/openvpn-install.sh
* https://remonpel.nl/2012/02/set-up-an-openvpn-server-on-your-mac/
* https://openvpn.net/community-resources/how-to/#setting-up-your-own-certificate-authority-ca-and-generating-certificates-and-keys-for-an-openvpn-server-and-multiple-clients
