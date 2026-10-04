# ☁️ Lyoko

☁️ Personnal files to run my HomeLab, deploying my infrastructure with ease using Ansible & Docker.

## ✨ Requirements

- Debian (12+)
- Ansible (Docker is installed automatically by the playbook)

## ✨ Setup & Run

```sh
cd ansible
cp group_vars/example.yml group_vars/all.yml
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install -r requirements.yml
ansible-playbook lyoko.yml -K -i inventory
```

## 💾 Backup / migration

Before wiping an old host, run the backup script on it. It stops the containers for a consistent snapshot, copies `/lyoko/apps` (app configs, databases, torrent stats/certificates) to a destination and starts them again. Media/torrents are intentionally not copied — copy the files you want to keep manually:

```sh
sudo ./scripts/backup-lyoko.sh /mnt/usb/lyoko-backup
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
- [Ygégé](https://github.com/uwucode/ygege) - YGG (ygg.gratis) Nostr indexer provider for Prowlarr
