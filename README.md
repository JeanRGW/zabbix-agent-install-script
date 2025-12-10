# zabbix-agent-install-script

Simple script to auto install zabbix agent on Ubuntu / Debian

## Usage

To install the Zabbix agent, run the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/JeanRGW/zabbix-agent-install-script/main/install-zabbix-agent.sh | sudo bash -s <zabbix-server>
```

Replace `<zabbix-server>` with the IP address or hostname of your Zabbix server.

### Example

```bash
curl -fsSL https://raw.githubusercontent.com/JeanRGW/zabbix-agent-install-script/main/install-zabbix-agent.sh | sudo bash -s 192.168.1.100
```

This will download and execute the installation script, automatically configuring the Zabbix agent to connect to the specified server.
