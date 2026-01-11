all:
  hosts:    
    ${vm_name}:
      ansible_host: ${vm_ip}
      ansible_user: ${ci_user}
      ansible_python_interpreter: /usr/bin/python3
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'