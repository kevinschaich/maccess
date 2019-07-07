# DEPRECATED - see [README.md](../README.md)

## OpenVPN Setup

> **Note:**	Steps 1-4 in this section should be completed on your server.

### Step 1: Installation

To set up a home VPN server, we'll be using an open-source tool called [OpenVPN](https://openvpn.net/). [Tunnelblick](https://tunnelblick.net/downloads.html) is a version for Mac which packs other things we need to get started. Let's install both via Homebrew:

```bash
brew install openvpn openssl
brew cask install tunnelblick
```

### Step 2: Server & Certificate Configuration

Open the newly installed **Tunnelblick** app in your **Applications** folder. Click through the intro prompts, choosing **I have configuration files** when asked. Once you've completed this, we'll navigate to the Tunnelblick configuration directory and edit the `vars` file:

```bash
cd ~/Library/Application\ Support/Tunnelblick/easy-rsa
vim vars
```

You can either adopt the template in `defaults/vars`, or edit this file manually. Scroll to the very bottom of the file and edit `KEY_COUNTRY`, `KEY_PROVINCE`, and `KEY_CITY` parameters to match your location. Once you're done, the last block should look something like this:

```bash
export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG=""
export KEY_EMAIL=""
export KEY_CN="server"
export KEY_NAME=""
export KEY_OU=""
export PKCS11_MODULE_PATH=""
export PKCS11_PIN=1234
```

> **Note:** The default expiration for certificates is 10 years, for your security, may want to change `CA_EXPIRE` and `KEY_EXPIRE` to something more reasonable like 365 (1 year).

Let's load this data into our terminal environment, then generate our CA certificate.

```bash
source ./vars
./clean-all
source ./vars
./build-ca
```

Just press the `Enter` key to accept the defaults. Next, we'll build our server certificate.

```bash
./build-key-server server
```

Enter through the steps, answering `y` for both `Sign the Certificate?` and `..., commit?` when asked. Next, we'll add a TLS Auth signature to increase security:

```bash
openvpn --genkey --secret keys/ta.key
```

> **Note:** If you have issues with this step, see [this](https://apple.stackexchange.com/questions/203115/installed-openvpn-with-brew-but-it-doesnt-appear-to-be-installed-correctly)

Lastly, we need to generate Diffie Hellman parameters (don't worry about understanding these – the TL;DR is that these are required for the OpenVPN server to work correctly and they help make your connection more secure).

```bash
./build-dh
```

### Step 3: Client Configuration

Next, we'll generate an OpenVPN Profile that we can import directly on our clients. Download the [default OpenVPN client configuration](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/client.conf) and save it to your Desktop. We need to make a few changes to this file.

Change the following line, replacing `my-server-1.mydomain.com` with the hostname we set up in the Dynamic DNS section: 

```
remote my-server-1.mydomain.com 1194
```

The actual file that clients require is quite simple, it's just a concatenation of all the certificate files. This can get a bit tedious for multiple clients though, so we'll utilize a bash function to make this faster. Again, you can accept the defaults here, just enter `y` on the last step. Copy and paste this entire block all at once into your terminal:

```bash
newclient () {
	echo "unique_subject = no" > keys/index.txt.attr
    export "KEY_CN=$1"
	./build-key "$1"
	cat ~/Desktop/client.conf > ~/"$1".ovpn
	echo "" >>  ~/"$1".ovpn
	echo "<ca>" >> ~/"$1".ovpn
	cat keys/ca.crt >> ~/"$1".ovpn
	echo "</ca>" >> ~/"$1".ovpn
	echo "<cert>" >> ~/"$1".ovpn
	sed -ne '/BEGIN CERTIFICATE/,$ p' keys/"$1".crt >> ~/"$1".ovpn
	echo "</cert>" >> ~/"$1".ovpn
	echo "<key>" >> ~/"$1".ovpn
	cat keys/"$1".key >> ~/"$1".ovpn
	echo "</key>" >> ~/"$1".ovpn
	echo "<tls-auth>" >> ~/"$1".ovpn
	sed -ne '/BEGIN OpenVPN Static key/,$ p' keys/ta.key >> ~/"$1".ovpn
	echo "</tls-auth>" >> ~/"$1".ovpn
}
```

Then, still within the `~/Library/Application\ Support/Tunnelblick/easy-rsa` folder, run:

```
newclient iphone8
```

for each client you'd like to connect to your network, replacing `iphone8` each time with a unique name you'll recognize. This will generate a file in `~/iphone8.ovpn` - copy this to your device.

### Step 4: Configuring the server to start automatically

### Step 5: Testing your connection

After all this is done, you should have a number of files in the `keys` directory. We'll move all of these to `/etc` so that 1) they don't get changed and 2) are secure & isolated from software like Spotlight, Dropbox, and Google Drive.

```bash
sudo mkdir -p /etc/openvpn/keys
sudo mv ~/Library/Application\ Support/Tunnelblick/easy-rsa/keys /etc/openvpn
```

Almost done – now we need to tell OpenVPN where to look for these certificates in a configuration file. Download the [default OpenVPN server configuration](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/server.conf) – we just need to make a few changes to this file.

If you want to access devices on your home network *besides* the server itself, uncomment the following line:

```
client-to-client
```

Finally, change all the following lines to match the paths of the certificates we just generated:

```
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key
dh /etc/openvpn/keys/dh2048.pem

tls-auth /etc/openvpn/keys/ta.key 
```

After you've made all these changes, save this file somewhere as `server.conf` and then drag & drop it into the sidebar of the **Configuration** tab in Tunnelblick. Click **Connect** and give it a few moments. If you get any popups that say `The IP address of this machine has not changed` or similar, that's OK, we aren't expecting it to change since it's the server. If your server startup was successful, you should see a line somewhere in the logs which contains:

```
Initialization Sequence Completed
```

Nicely done!

### TODO redirect all traffic
