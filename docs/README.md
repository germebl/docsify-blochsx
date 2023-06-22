# blochSX!
> The Perfect Linux Server

[![License](https://img.shields.io/badge/license-CC%20BY--NC%203.0-blue)](https://creativecommons.org/licenses/by-nc/3.0/)

## About the Project

!> This project is still experimental and **not for production NOR for development use**.

The blochSX project is a documentation guide for setting up the perfect Linux server. The components include:
- Wireguard
- Mattermost
- NGINX
- PHP8.2 FPM
- LEGO
- MySQL Server 8
- Dovecot
- Postfix
- rSpamd
- PowerDNS
- Fail2Ban
- Graylog
- (...)

## Prerequisites
> List of prerequisites to apply bloch.sx without major modifications

- Server Hosting: Hetzner Cloud Server
- DNS Provider: Hetzner DNS & own PowerDNS Nameservers
- Domain Provider: (optional)

> In this project, we use additional features of the Hetzner Cloud, such as the firewall, SSD volumes, private networks, and load balancers. Additional smaller tools or features may be utilized. Hetzner DNS and a own PowerDNS nameserver is used as the DNS provider for our wildcard SSL certificates.

> If you wish to use a different server hosting provider, you should be able to compensate for the specific parts that leverage Hetzner Cloud functionality. Other DNS providers are possible. All LEGO supported DNS providers are allowed. HTTP validation with acme.sh should not be used as not all servers will be accessible from outside.

## How to get started?

To install and set up the blochSX server, follow these steps:

1. **Prerequisites**: Make sure you have a Hetzner Cloud Account. If you wish to use a different server hosting provider or DNS provider, please feel free to do the necessary adjustments on your own.

2. **Information**: In this tutorial we will work with real ip-addresses and hostnames, to make it more understandable. Below you can find a list of all hostnames, ip-addresses (ipv4 & ipv6), DNS records and many more.

3. **Let's go**: To get started please read the documentation in the correct order you'll see in the sidebar. Each server we will setup, needs the `base` setup. From there you can do each setup.

| server | type     | name  | Public IPv4  | Public IPv6  | Private IPv4  |
|----------|----------|-------|-------|-------|-------|
| vpn | CX11 | vpn.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.0.2 |
| db-a | CX11 | db-a.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.3 |
| db-b | CX11 | db-b.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.4 |
| db-c | CX11 | db-c.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.5 |
| app-a | CX11 | app-a.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.6 |
| app-b | CX11 | app-b.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.7 |
| mx-a | CX11 | mx-a.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.8 |
| ns1 | CX11 | ns1.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.09 |
| ns2 | CX11 | ns2.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.10 |
| chat | CX11 | chat.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.11 |
| siem | CX11 | siem.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.12 |
| monitor | CX11 | monitor.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.13 |

| loadbalancer | type     | name  | Public IPv4  | Public IPv6  | Private IPv4  |
|----------|----------|-------|-------|-------|-------|
| db | LB11 | db.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.14 |
| app | LB11 | app.sudoers.biz | 127.0.0.1 | fe80::1 | 192.168.0.15 |


For more detailed information and advanced configurations, please refer to the complete blochSX documentation.

If you encounter any issues during the installation or setup process, feel free to seek support in the issue tracker or on [discord.bloch.sx](https://discord.bloch.sx).
```
