# Variables Proxmox
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox User"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox Password"
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "Proxmox IP/Hostname"
  type        = string
}

variable "proxmox_tls_insecure" {
  description = "Accept Insecure SSL"
  type        = bool
  default     = true
}

# Variables VM
variable "vm_name" {
  description = "VM Name"
  type        = string
  default     = "lyoko"
}

variable "vm_template" {
  description = "Cloud-Init template name"
  type        = string
  default     = "debian-13-cloudinit-template"
}

variable "target_node" {
  description = "Proxmox Node"
  type        = string
  default     = "pve"
}

variable "vm_cores" {
  description = "CPU Cores"
  type        = number
  default     = 2
}

variable "vm_sockets" {
  description = "Sockets"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "Memory"
  type        = number
  default     = 6144
}

variable "vm_onboot" {
  description = "Auto Start"
  type        = bool
  default     = true
}

# Variables Storage
variable "storage_name" {
  description = "Stockage LVM name"
  type        = string
  default     = "local-lvm"
}

variable "disk_percentage" {
  description = "Disk Percentage to use"
  type        = number
  default     = 95
  
  validation {
    condition     = var.disk_percentage > 0 && var.disk_percentage <= 100
    error_message = "Percentage should be between 1 et 100."
  }
}

# Variables Network
variable "network_bridge" {
  description = "Network Bridge"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network card model"
  type        = string
  default     = "virtio"
}

variable "vm_ip" {
  description = "IP of the VM"
  type        = string
  default     = "192.168.1.77"
}

variable "vm_gateway" {
  description = "Gateway IP"
  type        = string
  default     = "192.168.1.254"
}

variable "vm_nameserver" {
  description = "DNS Server"
  type        = string
  default     = "192.168.1.254"
}

# Variables Cloud-Init
variable "ci_user" {
  description = "Cloud-Init User"
  type        = string
  default     = "debian"
}

variable "ci_password" {
  description = "Temp Cloud-Init password"
  type        = string
  default     = "DummyPassword444!"
  sensitive   = true
}

variable "ssh_private_key_path" {
  description = "Private SSH Key path"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_public_key" {
  description = "Public SSH Key"
  type        = string
}

# Variables Ansible
variable "ansible_playbook_path" {
  description = "Path to the ansible playbook"
  type        = string
  default     = "../ansible/playbooks/lyoko.yml"
}

variable "ansible_inventory_path" {
  description = "Path to ansible inventory "
  type        = string
  default     = "../ansible/inventory/hosts.yml"
}

variable "ansible_wait_time" {
  description = "Wait time before executing Ansible"
  type        = number
  default     = 45
}

variable "run_ansible" {
  description = "Execute Ansible after VM creation"
  type        = bool
  default     = true
}
