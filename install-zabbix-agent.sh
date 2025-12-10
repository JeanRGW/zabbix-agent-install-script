#!/bin/bash
set -e

# Check argument
if [ -z "$1" ]; then
    echo "Usage: sudo bash $0 <zabbix-server-host>"
    echo "Example: sudo bash $0 junimo.rgw.ovh"
    exit 1
fi

ZBX_SERVER="$1"

echo "------------------------------------------"
echo " Zabbix Agent 2 Auto Installer (7.4)"
echo "------------------------------------------"
echo "Zabbix Server: $ZBX_SERVER"

# Detect OS
source /etc/os-release
OS=$ID
VER=$VERSION_ID

echo "Detected OS: $OS $VER"

# Install repo depending on OS
if [[ "$OS" == "ubuntu" ]]; then
    echo "Installing Zabbix repo for Ubuntu..."
    REPO_PKG="zabbix-release_latest_7.4+ubuntu${VER}_all.deb"
    wget -q "https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/${REPO_PKG}"
    dpkg -i "$REPO_PKG"
elif [[ "$OS" == "debian" ]]; then
    echo "Installing Zabbix repo for Debian..."
    REPO_PKG="zabbix-release_latest_7.4+debian${VER}_all.deb"
    wget -q "https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/${REPO_PKG}"
    dpkg -i "$REPO_PKG"
else
    echo "❌ Unsupported OS: $OS $VER"
    exit 1
fi

apt update
apt install -y zabbix-agent2

# Configure agent
CONF=/etc/zabbix/zabbix_agent2.conf
HOSTNAME=$(hostname)

echo "Configuring Zabbix Agent..."

sed -i "s/^Server=.*/Server=${ZBX_SERVER}/" "$CONF"
sed -i "s/^ServerActive=.*/ServerActive=${ZBX_SERVER}/" "$CONF"
sed -i "s/^Hostname=.*/Hostname=${HOSTNAME}/" "$CONF"

# Restart + enable
systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

echo "------------------------------------------"
echo " Zabbix Agent 2 Installed Successfully!"
echo "------------------------------------------"
echo "Server:   $ZBX_SERVER"
echo "Hostname: $HOSTNAME"
echo "Config:   $CONF"
echo "------------------------------------------"
echo "Make sure you set up Auto-registration on your Zabbix server."