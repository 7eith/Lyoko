# ☁️ Lyoko

☁️ Personnal files to run my HomeLab, deploying my infrastructure with ease using Ansible & Docker.

## ✨ Requirements

- Ansible

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
