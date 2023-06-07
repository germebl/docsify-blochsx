# Setup the VPN Server

This guide will walk you through the necessary preparations for configuring a Wireguard VPN server to build up a company network on a [Linux Debian 11 Base System](base.md). The setup will include the essential steps to install and configure the VPN server and how to connect clients from employees and open the wireguard port in iptables.

## Requirements

- [Debian 11 Base System](base.md)

## 1. Install Wireguard
The basic installation of wireguard is very simple. We just need to install it over the apt repositorys of our debian system:
```
apt install -y wireguard
```

## 2. Configure Wireguard Interface
Wireguard can handle as much interfaces as we want to have. In this case we only need a single interface for our employees. The configuration file for a Wireguard Interface is written within the `/etc/wireguard` folder as `{interface-name}.conf`.

In this case we create the file `/etc/wireguard/wg0.conf`:

```
nano /etc/wireguard/wg0.conf
```

We now need to copy and paste the following configuration:
```
[Interface]
Address = 10.0.0.1/32
ListenPort = 51820
PrivateKey = <SERVERS-PRIVATE-KEY>
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
```
systemctl start wg-quick@wg0
```

To enable the vpn to start on system startup, we need to enable the service:
```
systemctl enable wg-quick@wg0
```

Please check the status for issues with:
```
systemctl status wg-quick@wg0
```

## 3. Setup Firewall

Actually the port of iptables cant listen to any traffic, because the firewall does not allow traffic on port 51820. So we need to create a port to allow traffic from all sources to that port.

Because we use iptables-persistent, we will add this rule within the rules-file and then restore the rules to not accidentally set another rule like a fail2ban ssh ban permanently.

1. Open the file /etc/iptables/rules.v4 with `nano /etc/iptables/rules.v4`
2. After the rule `-A INPUT -p tcp --dport 22 -j ACCEPT` or `-A INPUT -p tcp --dport 22 -s 10.0.0.0/24 -j ACCEPT` start a new line
3. add the rule `-A INPUT -p udp --dport 51820 -j ACCEPT` to that new line
4. its very important, that its come before the rule with `-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT`
5. Restore the IPv4 Rules with `iptables-restore /etc/iptables/rules.v4`

## 4. How to connect a employee computer
Now we will explain how to connect a clients computer with the Wireguard VPN Server, which replicates the company network (wireguard network 10.0.0.0/24 as network for employee networks and hetzner private network 192.168.0.0/24 as private network for our servers).

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
  Address = 10.0.0.2/32

  [Peer]
  PublicKey = <SERVERS-PUBLIC-KEY>
  AllowedIPs = 192.168.0.0/24, 10.0.0.0/24
  Endpoint = <SERVERS-PUBLIC-IP>:51820
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
  AllowedIPs = 192.168.0.0/24, 10.0.0.0/24
  ```
  - Save the file and apply changes with `systemctl restart wg-quick@wg0`
  4. You should now be able to connect to the VPN server with the employees computer.
    - On Linux you need to start it with wg-quick@wg0 and can shut it down to wg-quick@wg0
    - On Windows you can just click `Activate` within the GUI
    - Test it with trying to `ping 192.168.0.0.2` to check if the vpn server is reachable with the ip address from hetzner network


## 5. Change the SSH IPTables Rule

!> As we already told you, its important to change the ssh iptables rule so only clients which are connected to the vpn server have the possibility to connect via ssh to the servers. For more information [check the base setup](base.md#3-firewall-configuration). We do not will inform you again.