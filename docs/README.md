# blochSX!
> The Perfect Linux Server

[![License](https://img.shields.io/badge/license-CC%20BY--NC%203.0-blue)](https://creativecommons.org/licenses/by-nc/3.0/)

## About the Project

!> This project is still experimental and **not for production NOR for development use**.

The blochSX project is a documentation guide for setting up the perfect Linux server. The components include:
- Wireguard
- NGINX
- PHP8.2 FPM
- MySQL Server 8
- Redis
- Dovecot
- Postfix
- rSpamd
- Fail2Ban
- Graylog
- (...)

## Prerequisites
> List of prerequisites to apply bloch.sx without major modifications

- Server Hosting: Hetzner Cloud Server
- DNS Provider: Cloudflare
- Domain Provider: (optional)

> In this project, we use additional features of the Hetzner Cloud, such as the firewall, SSD volumes, private networks, and load balancers. Additional smaller tools or features may be utilized. Cloudflare is used as the DNS provider for our wildcard SSL certificates.

> If you wish to use a different server hosting provider, you should be able to compensate for the specific parts that leverage Hetzner Cloud functionality. Other DNS providers are possible. All acme.sh supported DNS providers are allowed. HTTP validation with acme.sh should not be used as not all servers will be accessible from outside.

### How to get started?

To install and set up the blochSX server, follow these steps:

1. **Prerequisites**: Make sure you have a Hetzner Cloud and a Cloudflare Account. If you wish to use a different server hosting provider or DNS provider, please feel free to do the necessary adjustments on your own.

2. **Information**: In this tutorial we will work with real ip-addresses and hostnames, to make it more understandable. Below you can find a list of all hostnames, ip-addresses (ipv4 & ipv6), DNS records and many more.

3. **Let's go**: To get started please read the documentation in the correct order you'll see in the sidebar. Each server we will setup, needs the `base` setup. From there you can do each setup.

| server | type     | name  | IPv4  | IPv6  |
|----------|----------|-------|-------|-------|
| vpn | CX11 | vpn.sudoers.biz | 127.0.0.1 | fe80::1 |
| db | CX11 | db.sudoers.biz | 127.0.0.1 | fe80::1 |
| master | CX11 | master.sudoers.biz | 127.0.0.1 | fe80::1 |
| app | CX11 | app.sudoers.biz | 127.0.0.1 | fe80::1 |
| redis | CX11 | redis.sudoers.biz | 127.0.0.1 | fe80::1 |
| mail | CX11 | mail.sudoers.biz | 127.0.0.1 | fe80::1 |
| monitor | CX11 | monitor.sudoers.biz | 127.0.0.1 | fe80::1 |
| siem | CX11 | siem.sudoers.biz | 127.0.0.1 | fe80::1 |

For more detailed information and advanced configurations, please refer to the complete blochSX documentation.

If you encounter any issues during the installation or setup process, feel free to seek support in the issue tracker or on [discord.bloch.sx](https://discord.bloch.sx).
```
