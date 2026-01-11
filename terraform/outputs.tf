output "vm_ip" {
  description = "VM IP"
  value       = var.vm_ip
}

output "vm_id" {
  description = "VM ID inside Proxmox"
  value       = proxmox_vm_qemu.lyoko.id
}

output "vm_name" {
  description = "VM Name"
  value       = proxmox_vm_qemu.lyoko.name
}

output "disk_size_allocated" {
  description = "Disk allocated size"
  value       = "${data.external.available_space.result.size}G"
}

output "ssh_connection" {
  description = "SSH connexion command"
  value       = "ssh ${var.ci_user}@${proxmox_vm_qemu.lyoko.default_ipv4_address}"
}

output "ansible_command" {
  description = "Command to launch ansible yourself"
  value       = "cd ../ansible && ansible-playbook -i ${var.ansible_inventory_path} ${var.ansible_playbook_path}"
}