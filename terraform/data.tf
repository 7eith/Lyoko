data "external" "available_space" {
  program = ["bash", "${path.module}/scripts/get_available_space.sh"]
  
  query = {
    host       = var.proxmox_host
    user       = split("@", var.proxmox_user)[0]
    storage    = var.storage_name
    node       = var.target_node
    percentage = var.disk_percentage
  }
}