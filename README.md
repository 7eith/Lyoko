# ☁️ Lyoko

☁️ Personnal files to run my HomeLab, deploying my infrastructure with ease using Ansible & Docker.

## ✨ Requirements

- Debian (12+)
- Ansible (Docker is installed automatically by the playbook)

## ✨ Setup & Run

```sh
cd ansible
cp group_vars/example.yml group_vars/all.yml
ansible-playbook lyoko.yml -K -i inventory
```

## ☁️ Applications

- [Traefik](https://traefik.io/) - Web proxy and SSL certificate manager
- [Homepage](https://gethomepage.dev/) - Highly customizable Dashboard
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - Password Manager
- [Gluetun](https://github.com/qdm12/gluetun) - VPN Client in a thin Docker container
- [qBitTorrent](https://www.qbittorrent.org/) - BitTorrent Client
- [QUI](https://github.com/autobrr/qui) - Better WebUI for qBitTorrent (multiple instances, cross-seed...)
- [Jellyfin](https://jellyfin.org/) - Media System
- [ProwlArr](https://prowlarr.com/) - Indexer Manager
- [SonArr](https://sonarr.tv/) - Series Manager
- [RadArr](https://radarr.video/) - Movies Manager
- [ProfilArr](https://github.com/Dictionarry-Hub/profilarr) - Quality Profiles Manager ([My profiles](https://github.com/7eith/lyoko-arr-custom-formats))
