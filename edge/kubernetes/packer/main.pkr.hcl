source "proxmox-iso" "main" {
  # Proxmox Connection Settings
  proxmox_url              = var.pm_api_url
  username                 = var.pm_api_token_id
  token                    = var.pm_api_token_secret
  insecure_skip_tls_verify = true

  # VM General Settings.
  node                 = var.pm_target_node_name
  vm_id                = var.vm_id
  vm_name              = var.vm_template_name
  template_description = var.vm_template_description

  # VM System Settings
  qemu_agent = true

  # VM CPU Settings
  cores = var.vm_cores

  # VM memory Settings
  memory = var.vm_memory

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"
  disks {
    type         = "virtio"
    disk_size    = var.vm_disk_size
    storage_pool = "local-lvm"
  }

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }
  boot_iso {
    type             = "ide"
    iso_file         = var.iso_file
    unmount          = true
    iso_storage_pool = "local"
  }
  boot_wait = "5s"
  boot_command = [
    "c <wait>",
    "linux /casper/vmlinuz --- ",
    "autoinstall ds='nocloud-net;s=http://192.168.1.211:8336/' <enter><wait3s>",
    "initrd /casper/initrd <enter><wait3s>",
    "boot <enter>",
  ]
  ssh_timeout             = "30m"
  ssh_username            = var.vm_admin_username
  ssh_password            = var.vm_admin_password
  cloud_init_storage_pool = "local-lvm" # Specify where to store the Cloud-Init CDROM.
  cloud_init              = true        # Add an empty Cloud-Init CDROM drive after the virtual machine has been converted to a template.
}

build {
  sources = [ "source.proxmox-iso.main" ]
  provisioner "ansible" {
    playbook_file          = "../ansible/playbook.yaml"
    extra_arguments = [
      "--scp-extra-args", "'-O'"
    ]
  }
}
