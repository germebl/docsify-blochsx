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