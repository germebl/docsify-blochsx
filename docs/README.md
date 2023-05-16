# blochSX
> Der perfekte Linux Server

[![License](https://img.shields.io/badge/license-CC%20BY--NC%203.0-blue)](https://creativecommons.org/licenses/by-nc/3.0/)

## Über das Projekt

Das Projekt blochSX ist eine Dokumentation zur Einrichtung des perfekten Linux Servers. Die Komponenten sind unter anderem:
- Wireguard
- NGINX
- PHP8.2 FPM
- MySQL Server 8
- Redis
- Dovecot
- Postfix
- rSpamd
- Fail2Ban
- graylog
- (...)

## Choose your way

Suche dir deinen Weg aus. 

Wähle die Deployment Methode:
 - Ansible Playbook
 - manuelle Installation

Wähle die Server-Art:
 - Single Server Setup
 - Multi Server Setup

## Voraussetzungen
> Liste der Voraussetzungen um bloch.sx ohne größere Anpassungen anzuwenden

- Server Hosting:   Hetzner Cloud Server
- DNS Provider:     Cloudflare
- Domain Provider:  (optional)

> In diesem Projekt nutzen wir neben den Hetzner Cloud Servern weitere Funktionen der Hetzner Cloud. Dazu gehört die Firewall, SSD Volumes, private Netzwerke, Loadbalancer. Eventuell werden weitere kleinere Tools oder Funktionen genutzt. Cloudflare kommt als DNS Provider zum Einsatz für unsere Wildcard SSL Zertifikate.

> Wer einen anderen Server Hoster nutzen möchte, sollte die entsprechenden Teile, die uns die Hetzner Cloud Funktionalität abnimmt, selbst kompensieren können.  Andere DNS Provider sind möglich. Es sind alle acme.sh unterstützten DNS Provider möglich. http Validation bei acme.sh sollte nicht genutzt werden, da nicht alle Server von außen erreichbar sein werden.