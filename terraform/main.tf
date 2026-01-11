resource "proxmox_vm_qemu" "lyoko" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.vm_template
  
  start_at_node_boot = var.vm_onboot
  agent              = 0
  
  # CPU
  cpu {
    cores   = var.vm_cores
    sockets = var.vm_sockets
    type    = "host"  # best performance
  }
  
  # Memory
  memory    = var.vm_memory

  # Disk Size
  disks {
    scsi {
      scsi0 {
        disk {
          size    = "${data.external.available_space.result.size}G"
          storage = var.storage_name
        }
      }
    }
  } 
  
  # Network
  network {
    id     = 0
    model  = var.network_model
    bridge = var.network_bridge
  }
  
  # Cloud-Init
  os_type      = "cloud-init"
  ipconfig0    = "ip=${var.vm_ip}/24,gw=${var.vm_gateway}"
  nameserver   = var.vm_nameserver
  searchdomain = "lan"

  ciuser     = var.ci_user
  cipassword = var.ci_password
  cicustom   = "user=local:snippets/cloud-init-user.yml"
  sshkeys    = var.ssh_public_key
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

# Create Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.yml.tpl", {
    vm_name    = var.vm_name
    vm_ip      = var.vm_ip
    ci_user    = var.ci_user
  })
  filename = var.ansible_inventory_path
  
  depends_on = [proxmox_vm_qemu.lyoko]
}

# Provision Ansible
resource "null_resource" "ansible_provisioning" {
  count = var.run_ansible ? 1 : 0
  
  triggers = {
    vm_id = proxmox_vm_qemu.lyoko.id
  }
  
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/run_ansible.sh ${var.vm_ip} ${var.ansible_wait_time} lyoko.yml"
  }
  
  depends_on = [
    proxmox_vm_qemu.lyoko,
    local_file.ansible_inventory
  ]
}