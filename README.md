# ☁️ Lyoko

☁️ Personnal files to run my HomeLab, deploying my infrastructure with ease using Ansible & Docker.

## ✨ Requirements

- Proxmox
- OpenTofu / Terraform
- Ansible

## ✨ Setup (Proxmox)

### Cloud-Init VM

Download Debian (Trixie-13) and Configure the VM

```sh
cd /tmp
wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2

qm create 9000 --name debian-13-cloudinit-template --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk 9000 debian-13-generic-amd64.qcow2 local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000
```

### Terraform Access

Create Terraform Role

```sh

pveum role add Terraform -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"
```

Create Terraform User

```sh

pveum user add terraform@pve --password <password> -comment "Terraform account"

```

Give Role to User

```sh

pveum aclmod / -user terraform@pve -role Terraform
```

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
