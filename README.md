# ☁️ Lyoko

☁️ Personnal files to run my HomeLab, deploying my infrastructure with ease using Ansible & Docker.

## ✨ Requirements

- Proxmox
- OpenTofu / Terraform (WIP)
- Ansible

## ✨ Configuration (qBit - Gluetun - NordVPN)

### 📌 qBit

access to your qbit instance and update configuration to use gluetun as proxy

```md
• Settings → Connection (Listening Port):
Port used for incoming connections: RANDOM

• Settings → Connection (Proxy Server):
HTTP - gluetun - 8888

✅ use proxy for peer connections
✅ use proxy for RSS purposes
❌ use proxy for general purposes (webui)
```

### 📌 NordVPN

go to the dashboard → Advanced Settings → Set up NordVPN Manually → [Service credentials](https://my.nordaccount.com/dashboard/nordvpn/manual-configuration/service-credentials/)
use these credentials inside vars

## ✨ Setup & Run

```sh
cd ansible
cp group_vars/lyoko/example.yml group_vars/lyoko/all.yml
ansible-playbook lyoko.yml -K -i inventory
```

## ☁️ Applications

- [Traefik](https://traefik.io/) - Web proxy and SSL certificate manager
- [Homepage](https://gethomepage.dev/) - Highly customizable Dashboard
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - Password Manager
- [Jellyfin](https://jellyfin.org/) - Media System
- [qBitTorrent](https://www.qbittorrent.org/) - BitTorrent Client
- [ProwlArr](https://prowlarr.com/) - Indexer Manager
- [SonArr](https://sonarr.tv/) - Series Manager
- [RadArr](https://radarr.video/) - Movies Manager
- [Gluetun](https://github.com/qdm12/gluetun) - VPN Client in a thin Docker container
