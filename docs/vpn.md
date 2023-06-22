# Setup the VPN Server

This guide will walk you through the necessary preparations for configuring a Wireguard VPN server, to connect company employees devices, based on a [Linux Debian 11 Base System](base.md). The setup will include the essential steps to install and configure the VPN server and how to connect clients from employees and open the wireguard port in iptables.

## Prerequisites

- 1 node with [Debian 11 Base System](base.md)

## 1. Install Wireguard
The basic installation of wireguard is very simple. We just need to install it over the apt repositorys of our debian system:
```
apt install -y wireguard
```

## 2. Configure Wireguard Interface
Wireguard can handle as much interfaces as we want to have. In this case we only need a single interface for our employees. The configuration file for a Wireguard Interface is written within the `/etc/wireguard` folder as `{interface-name}.conf`.

Before we do this we need to create a public and private key which we will use within our servers and clients configuration and secure the privatekey with good permissions:
```bash
cd /etc/wireguard
wg genkey | tee privatekey | wg pubkey > publickey
chmod 0600 privatekey
```

In this case we create the file `/etc/wireguard/wg0.conf`:

```
nano /etc/wireguard/wg0.conf
```

We now need to copy and paste the following configuration:
```
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <SERVERS-PRIVATE-KEY>
MTU = 1300
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE;
```

You can create a private & public key as follows:
```
cd /etc/wireguard
wg genkey | tee privatekey | wg pubkey > publickey
chmod 0600 privatekey
```

Please replace `<SERVERS-PRIVATE-KEY>` with the privatekey we have recently created. You can view it as follows:
```
cat /etc/wireguard/privatekey
```

We can now start the Wireguard VPN server and it's interface:
```bash
systemctl start wg-quick@wg0
```

To enable the vpn to start on system startup, we need to enable the service:
```bash
systemctl enable wg-quick@wg0
```

Please check the status for issues with:
```bash
systemctl status wg-quick@wg0
```

## 3. How to connect a employee computer
Now we will explain how to connect a clients computer with the Wireguard VPN Server, which replicates the company network.

1. [Install Wireguard on the employees computer](https://www.wireguard.com/install/)
  - On Linux the configuration file is here: `/etc/wireguard/wg0.conf`
    - On Linux you need to create the private & public key yourself:
    ```
    cd /etc/wireguard
    wg genkey | tee privatekey | wg pubkey > publickey
    chmod 0600 privatekey
    ```
  - On Windows you need to create the configuration file within the GUI
2. Fill the configuration file with the following configuration:
  ```
[Interface]
PrivateKey = <CLIENTS-PRIVATE-KEY>
Address = 10.0.0.1/32
DNS = 1.1.1.1, 1.0.0.1
MTU = 1300

[Peer]
PublicKey = <SERVERS-PUBLIC-KEY>
PresharedKey = tpDlOWIfyB+DH+syZ5y3Ci9Iq1uTxindHPKPaZ6aC+Y=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = <SERVERS-PUBLIC-IP>:51820
PersistentKeepalive = 15

  ```
  - Replace `<CLIENTS-PRIVATE-KEY>` with the on the client generated or already available private key
  - Replace `<SERVERS-PUBLIC-KEY>` with the on the server created public key
  - Replace `<SERVERS-PUBLIC-IP>` with the public ip address of the vpn server
  
  !> The `Address = 10.0.0.2/32` is the second ip address of this network. The first is from the vpn server itself. When you add new employee computers, you need to count up that number. 

3. Open the servers configuration file within `/etc/wireguard/wg0.conf` with `nano /etc/wireguard/wg0.conf`
  - Add the Peer (Client) to the end of the file:
```
[Peer]
PublicKey = <CLIENTS-PUBLIC-KEY>
PresharedKey = tpDlOWIfyB+DH+syZ5y3Ci9Iq1uTxindHPKPaZ6aC+Y=
AllowedIPs = 172.30.0.2/32
```
- Replace `<CLIENTS-PUBLIC-KEY>` with the public key of the client
- Save the file and apply changes with `systemctl restart wg-quick@wg0`

4. You should now be able to connect to the VPN server with the employees computer.
  - On Linux you need to start it with wg-quick@wg0 and can shut it down to wg-quick@wg0
  - On Windows you can just click `Activate` within the GUI

## 4. Setup Firewall

Actually the wireguard interface cant listen to any traffic, because the firewall does not allow traffic on port 51820. So we need to create a port to allow traffic from all sources to that port. In this case the SSH Rule will not get edited to add the source-ip of the vpn server, because we do not want to have a single-point-of-failure (When connecting to SSH is only possible while connected to the VPN but the VPN has a problem, we wouldnt be able to connect to the vpn server via ssh anymore.)

Because we use iptables-persistent, we will add this rule within the rules-file and then restore the rules to not accidentally set another rule like a fail2ban ssh ban permanently.

1. Open the file /etc/iptables/rules.v4 with `nano /etc/iptables/rules.v4`
2. add the rule `-A INPUT -p udp --dport 51820 -j ACCEPT` to that new line
3. its very important, that its come before the rule with `-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT`
4. Restore the IPv4 Rules with `iptables-restore /etc/iptables/rules.v4`

## 5. DNS

You should create the following DNS records:

| type | name | value  | priority |
|----------|----------|-------|-------|
| A | vpn.sudoers.biz | <public-ip-v4-vpn-server> | - |
| AAAAAA | vpn.sudoers.biz | <public-ip-v6-vpn-server> | - |

- Replace `<public-ip-v4-vpn-server>`
- Replace `<public-ip-v6-vpn-server>`