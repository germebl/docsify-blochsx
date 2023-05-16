<!-- TODO: Update with your values. -->
# blochSX
> Der perfekte Linux Server

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://creativecommons.org/license/by/4.0/)

## Über das Projekt

Das Projekt blochSX ist eine Dokumentation zur Einrichtung des perfekten Linux Servers. Die Komponenten sind unter anderem:
- Wireguard
- NGINX
- PHP8.2 FPM
- MySQL Server 8
- Dovecot
- Postfix
- rSpamd
- Fail2Ban
- (...)

!> Das Projekt befindet sich aktuell in der Entwicklung und ist somit **WIP** und nicht zwingend funktionstüchtig. Ab dem Release von Version 1.0.0 wird es das erste mal stable sein.


## Anbieter Voraussetzungen
> Liste der Voraussetzungen um bloch.sx ohne größere Anpassungen anzuwenden:

- Server Hosting:   Hetzner Cloud Server
- DNS Provider:     Cloudflare
- Domain Provider:  (optional)

In diesem Projekt nutzen wir neben den Hetzner Cloud Servern weitere Funktionen der Hetzner Cloud. Dazu gehört die Firewall, SSD Volumes, private Netzwerke, Loadbalancer. Eventuell werden weitere kleinere Tools oder Funktionen genutzt.

Wer einen anderen Server Hoster nutzen möchte, sollte die entsprechenden Teile, die uns die Hetzner Cloud Funktionalität abnimmt, selbst kompensieren können.

Der DNS Provider ist in diesem Fall Cloudflare, um einen DNS Provider zu haben für unsere Wildcard SSL Zertifikate. Es sind allerdings alle acme.sh unterstützten DNS Provider möglich.

## System Voraussetzungen
> Übersicht der Voraussetzungen für die genutzten Systeme

### Alle Systeme
- Debian:       11

### VPN Server
- (v)CPU:          4
- RAM:             4 GB
- SSD Volume:      mind. 10 GB
- Pub. IPv4/IPv6:  Ja

### Web/PHP Server
- (v)CPU:          4
- RAM:             4 GB
- SSD Volume:      mind. 10 GB
- Pub. IPv4/IPv6:  Ja

### DB Server
- (v)CPU:          4
- RAM:             8 GB
- SSD Volume:      mind. 100 GB
- Pub. IPv4/IPv6:  Nein

## Redis Server
- (v)CPU:          4
- RAM:             4 GB
- SSD Volume:      mind. 20 GB
- Pub. IPv4/IPv6:  Nein

### Mail Server
- (v)CPU:          4
- RAM:             4 GB
- SSD Volume:      mind. 60 GB
- Pub. IPv4/IPv6:  Ja

### Monitoring Server
- (v)CPU:          4
- RAM:             8 GB
- SSD Volume:      mind. 60 GB
- Pub. IPv4/IPv6:  Nein

### Logging/SIEM Server
- (v)CPU:          4
- RAM:             8 GB
- SSD Volume:      mind. 100 GB
- Pub. IPv4/IPv6:  Nein

## Quick Start

Um ein blochSX Single Server oder Multi Server Setup in wenigen Schritten anzuwenden, steht ein Ansible Playbook zur Verfügung.

!> Das Playbook unterstützt aktuell nur das Ausführen von einem Linux Host! Python3 PIP & Ansible müssen bereits installiert sein.

Um dies anwenden zu können benötigen Sie folgendes:
- Eine Domain die per Nameserver auf die Cloudflare DNS Server zeigt
- Die Domain sollte als Site bei Cloudflare angelegt sein
- Die Domain sollte bestenfalls keine DNS Records haben, außer die NS Einträge
- Die Account-ID sowie einen API Token von Cloudflare
- Ein vorhandenes Hetzner Cloud Projekt
- Ein API Token aus dem Hetzner Cloud Projekt

Während das Playbook läuft, müssen Sie:
- Ihre Domain angeben (keine Subdomains!)
- Ihren Hetzner Cloud API Token hinterlegen
- Ihre Cloudflare Account-ID & API Token hinterlegen
- Entscheiden ob ein Single Server oder Multi Server Setup
- Ob Sie eine minimale oder empfohlene Leistung bevorzugen

Sobald die Variablen übergeben wurden, installiert das Ansible Playbook das gewünschte Setup und erstellt dabei selbstständig die benötigten Server, SSD Volumes, privaten Netzwerke, legt DNS Records fest, installiert & konfiguriert die entsprechenden Services und konfiguriert die Hetzner Cloud Firewall. Sobald das Setup durchgelaufen ist, wird Ihnen eine README.md auf dem Server, auf dem das Playbook ausgeführt wurde, im /root Verzeichnis abgelegt. Diese README.md enthält anschließend eine umfangreiche Dokumentation zu ihren Server/n und erklärt Ihnen, wie Sie diese Server nun nutzen können.

Sie können das Playbook wiefolgt herunterladen:
```bash
*WORK IN PROGRESS*
```

Anschließend können Sie es mit Ansible wie folgt ausführen:
```bash
*WORK IN PROGRESS*
```