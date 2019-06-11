# OpenVPN Setup

### Installation

To set up a home VPN server, we'll be using an open-source tool called Tunnelblick. It comes with everything you need to get started.

Via [Homebrew](https://brew.sh):

```bash
brew cask install tunnelblick
```

Via web download:

[Download Tunnelblick](https://tunnelblick.net/downloads.html)

### Server & Certificate Configuration

The instructions in this section should be completed on your home Mac that you want to use as a server.

Navigate to the Tunnelblick configuration directory created by the installation step above and edit the `vars` file:

```bash
cd ~/Library/Application\ Support/Tunnelblick/easy-rsa
vim vars
```

Scroll to the very bottom of the file and edit `KEY_COUNTRY`, `KEY_PROVINCE`, and `KEY_CITY` parameters to match your location. Once you're done, the last block should look something like this:

```bash
export KEY_COUNTRY='US'
export KEY_PROVINCE='CA'
export KEY_CITY='SanFrancisco'
export KEY_ORG=''
export KEY_EMAIL=''
export KEY_CN='server'
export KEY_NAME=''
export KEY_OU=''
export PKCS11_MODULE_PATH=''
export PKCS11_PIN=1234
```

> **Note:** The default expiration for certificates is 10 years, for your security, may want to change `CA_EXPIRE` and `KEY_EXPIRE` to something more reasonable like 365 (1 year).

Let's start fresh and load this data into our terminal environment, then generate our CA certificate.

```bash
./clean-all
source ./vars
./build-ca
```

Provided you've edited the `vars` file above, you can just press the `Enter` key to accept the defaults. When you get to the last step, enter `y` to sign the certificate and then press `Enter`. Next, we'll build our server certificate.

```bash
export KEY_CN='server' && ./build-key-server $KEY_CN
```

Again, the defaults are fine here. Lastly, we need to generate Diffie Hellman parameters (don't worry about understanding these – the TL;DR is that these are required for the OpenVPN server to work correctly and they help make your connection more secure).

```bash
./build-dh
```

After all this is done, you should have a number of files in the `keys` directory. We'll move all of these to `/etc` so that 1) they don't get changed and 2) are secure & isolated from software like Spotlight, Dropbox, and Google Drive.

```bash
mkdir -p /etc/openvpn
sudo mv ~/Library/Application\ Support/Tunnelblick/easy-rsa/keys /etc/openvpn
```

Almost done – now we need to tell OpenVPN where to look for these certificates in a configuration file. Download the [default OpenVPN server configuration](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/server.conf) – we just need to make a few changes to this file.

Comment out the following line:

```
tls-auth ta.key
```

If you want to access devices on your home network *besides* the server itself, uncomment the following line:

```
client-to-client
```

Finally, change the following lines to match the paths of the certificates we just generated:

```
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key
dh /etc/openvpn/keys/dh2048.pem
```

After you've made all these changes, save this file as `server.conf` and then drag & drop it into the sidebar of the **Configuration** tab in Tunnelblick. Click **Connect** and give it a few moments – if your server startup was successful, you should see a line somewhere in the logs which contains:

```
Initialization Sequence Completed
```

If you get any popups that say `The IP address of this machine has not changed` or similar, that's OK, we aren't expecting it to change since it's the server.

### Client Configuration

Again, you can accept the defaults here, just enter `y` on the last step. Next, we'll build our client certificate. This time, change `server` to something you'll recognize, like `client1`.

```bash
export KEY_CN='client1' ./build-key $KEY_CN
```

Repeat these steps for as many devices as you'd like to connect to your home VPN.


Download the [default OpenVPN client configuration](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/client.conf) and save it to your Desktop. We need to make a few changes to this file.

Comment out the following line:

```
tls-auth ta.key 1
```

Change the following line, replacing `my-server-1.mydomain.com` with the hostname we set up in the Dynamic DNS section: 

```
remote my-server-1.mydomain.com 1194
```

Again, change the following lines to match the names of the *client* certificates we generated earlier:

```
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/client1.crt
key /etc/openvpn/keys/client1.key
```

Next, we'll generate an OpenVPN Profile that we can import directly on our clients.

```bash
# Generates the custom client.ovpn
cp /etc/openvpn/keys/client-common.txt ~/$1.ovpn
echo "<ca>" >> ~/$1.ovpn
cat /etc/openvpn/keys/easy-rsa/pki/ca.crt >> ~/$1.ovpn
echo "</ca>" >> ~/$1.ovpn
echo "<cert>" >> ~/$1.ovpn
sed -ne '/BEGIN CERTIFICATE/,$ p' /etc/openvpn/keys/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
echo "</cert>" >> ~/$1.ovpn
echo "<key>" >> ~/$1.ovpn
cat /etc/openvpn/keys/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
echo "</key>" >> ~/$1.ovpn
echo "<tls-auth>" >> ~/$1.ovpn
sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/keys/ta.key >> ~/$1.ovpn
echo "</tls-auth>" >> ~/$1.ovpn
```

### Configuring the server to start automatically

### Generating client profiles

### TODO redirect all traffic
