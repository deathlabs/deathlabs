resource "proxmox_vm_qemu" "controller" {
  target_node = var.pm_target_node_name
  clone       = var.vm_template_name
  vmid        = var.controller_vm_id
  name        = var.controller_name
  agent       = 1 # Enable the QEMU agent service.
  cpu         = "host"
  sockets     = var.controller_socket_count
  cores       = var.controller_cores_count
  memory      = var.controller_memory_size
  os_type     = "cloud-init"
  disks {
    virtio {
      virtio0 {
        disk {
          size    = var.controller_disk_size
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }

  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=${var.controller_ip_address}/24,gw=${var.gateway_ip_address}"
}

resource "proxmox_vm_qemu" "worker" {
  for_each = {
    for worker_id in local.worker_ids :
    tostring(worker_id) => worker_id
  }

  target_node = var.pm_target_node_name
  clone       = var.vm_template_name
  vmid        = var.controller_vm_id + each.value + 1
  name        = "${var.worker_name_prefix}-${each.value}"
  agent       = 1 # Enable the QEMU agent service.
  cpu         = "host"
  sockets     = var.worker_socket_count
  cores       = var.worker_cores_count
  memory      = var.worker_memory_size
  os_type     = "cloud-init"
  disks {
    virtio {
      virtio0 {
        disk {
          size    = var.worker_disk_size
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=${local.worker_ip_addresses[each.value]}/24,gw=${var.gateway_ip_address}"
}
