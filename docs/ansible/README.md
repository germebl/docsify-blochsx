# ANSIBLE README

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