source "proxmox-iso" "main" {
  # Proxmox connection Settings
  proxmox_url              = var.pm_api_url
  username                 = var.pm_api_token_id
  token                    = var.pm_api_token_secret
  insecure_skip_tls_verify = true

  # VM general settings.
  node                 = var.pm_target_node_name
  vm_id                = var.vm_id
  vm_name              = var.vm_template_name
  template_description = var.vm_template_description

  # VM system settings.
  qemu_agent = true
  scsi_controller = "virtio-scsi-pci"

  # VM CPU settings.
  sockets = var.vm_socket_count
  cores   = var.vm_core_count

  # VM memory settings.
  memory = var.vm_memory_gb_size * 1024

  # Cloud init settings.
  cloud_init              = true        # Add an empty Cloud-Init CDROM drive after the virtual machine has been converted to a template.
  cloud_init_storage_pool = "local-lvm" # Specify where to store the Cloud-Init CDROM.
  cloud_init_disk_type    = "scsi"

  # VM storage settings.
  disks {
    type         = "virtio"
    disk_size    = "${var.vm_disk_gb_size}G"
    storage_pool = "local-lvm"
  }

  # VM network settings.
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  # VM boot settings.
  boot_iso {
    type             = "ide"
    iso_file         = "local:iso/${var.iso_file_name}"
    unmount          = true
    iso_storage_pool = "local"
  }
  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- ",
    "autoinstall ds='nocloud-net;s=http://${var.cloud_init_server_ip_address}:${var.cloud_init_server_port}/' <enter><wait3s>",
    "initrd /casper/initrd <enter><wait3s>",
    "boot <enter>",
  ]

  # SSH settings.
  ssh_timeout  = "30m"
  ssh_username = var.vm_admin_username
  ssh_password = var.vm_admin_password
}

build {
  sources = ["source.proxmox-iso.main"]
  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yaml"
    extra_arguments = [
      "--scp-extra-args", "'-O'"
    ]
  }
}
