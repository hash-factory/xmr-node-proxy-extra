#!/bin/bash
echo "Continuing install, this will prompt you for your password if you're not already running as root and you didn't enable passwordless sudo.  Please do not run me as root!"
if [[ `whoami` == "root" ]]; then
    echo "You ran me as root! Do not run me as root!"
    exit 1
fi
CURUSER=$(whoami)
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install git curl build-essential cmake python-virtualenv libboost-all-dev
cd ~
nvm install v8.11.3
nvm alias default v8.11.3
cd ~/xmr-node-proxy-extra
npm install || exit 1
cp config_example.json config.json
openssl req -subj "/C=IT/ST=Pool/L=Daemon/O=Mining Pool/CN=mining.proxy" -newkey rsa:2048 -nodes -keyout cert.key -x509 -out cert.pem -days 36500
cd ~
sudo env PATH=$PATH:`pwd`/.nvm/versions/node/v8.11.3/bin `pwd`/.nvm/versions/node/v8.11.3/lib/node_modules/pm2/bin/pm2 startup systemd -u $CURUSER --hp `pwd`
echo "You're setup with a shiny new proxy!  Now, go configure it and have fun."
