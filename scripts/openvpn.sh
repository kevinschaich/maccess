if [ $# -eq 0 ]; then
    echo "usage: openvpn.sh [client1-name] [client2-name] [...]"
    exit 1
fi

# Install Dependencies
brew tap riboseinc/easy-rsa
brew install openvpn openssl easy-rsa
# brew cask install tunnelblick

# Generate common & server keys
easyrsa --batch --vars=./vars init-pki
easyrsa --batch --vars=./vars build-ca nopass
easyrsa --batch --vars=./vars build-server-full server nopass
easyrsa --batch --vars=./vars gen-dh
openvpn --genkey --secret pki/ta.key

# Generate a client key
buildClient () {
	easyrsa --batch --vars=./vars build-client-full $1 nopass
	cat ./config/client.conf > ./clients/"$1".ovpn
    echo "" >> ./clients/"$1".ovpn
	echo "<ca>" >> ./clients/"$1".ovpn
	cat pki/ca.crt >> ./clients/"$1".ovpn
	echo "</ca>" >> ./clients/"$1".ovpn
	echo "<cert>" >> ./clients/"$1".ovpn
	sed -ne '/BEGIN CERTIFICATE/,$ p' pki/issued/"$1".crt >> ./clients/"$1".ovpn
	echo "</cert>" >> ./clients/"$1".ovpn
	echo "<key>" >> ./clients/"$1".ovpn
	cat pki/private/"$1".key >> ./clients/"$1".ovpn
	echo "</key>" >> ./clients/"$1".ovpn
	echo "<tls-auth>" >> ./clients/"$1".ovpn
	sed -ne '/BEGIN OpenVPN Static key/,$ p' pki/ta.key >> ./clients/"$1".ovpn
	echo "</tls-auth>" >> ./clients/"$1".ovpn
}

rm -rf ./clients
mkdir -p ./clients

# Loop through script arguments to generate clients
for client in "$@"
do
    buildClient "$client"
done
