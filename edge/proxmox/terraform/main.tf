resource "proxmox_vm_qemu" "controller" {
  for_each = local.controller_ids

  target_node = var.pm_target_node_name

  clone = var.vm_template_name
  vmid  = local.controller_vmid_map[each.value]
  name  = "${var.controller_name_prefix}-${each.value}"
  
  cpu {
    sockets = var.controller_socket_count
    cores   = var.controller_cores_count
  }
  
  memory = var.controller_memory_size
  
  disks {
    scsi {
      scsi0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = var.controller_disk_size
          storage = "local-lvm"
        }
      }
    }
  }

  os_type = "cloud-init"

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=${local.controller_ip_addresses[each.value]}/24,gw=${var.gateway_ip_address}"
}

resource "proxmox_vm_qemu" "worker" {
  for_each = local.worker_ids

  target_node = var.pm_target_node_name
  
  clone = var.vm_template_name
  vmid  = local.worker_vmid_map[each.value]
  name  = "${var.worker_name_prefix}-${each.value}"
  
  cpu {
    sockets = var.worker_socket_count
    cores   = var.worker_cores_count
  }
  
  memory = var.worker_memory_size
  
  disks {
    scsi {
      scsi0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = var.worker_disk_size
          storage = "local-lvm"
        }
      }
    }
  }

  os_type = "cloud-init"
  
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=${local.worker_ip_addresses[each.value]}/24,gw=${var.gateway_ip_address}"
}
