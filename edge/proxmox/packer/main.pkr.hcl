source "proxmox-iso" "main" {
  proxmox_url              = var.pm_api_url
  username                 = var.pm_api_token_id
  token                    = var.pm_api_token_secret
  insecure_skip_tls_verify = true

  node                 = var.pm_target_node_name
  vm_id                = var.vm_id
  vm_name              = var.vm_template_name
  template_description = var.vm_template_description

  sockets = var.vm_socket_count
  cores   = var.vm_core_count

  memory = var.vm_memory_gb_size * 1024

  disks {
    type         = "virtio"
    disk_size    = "${var.vm_disk_gb_size}G"
    storage_pool = "local-lvm"
  }

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  http_bind_address = "0.0.0.0"
  http_port_min     = var.cloud_init_server_port
  http_port_max     = var.cloud_init_server_port
  http_directory    = "cloud-init"

  boot_iso {
    iso_file = "local:iso/${var.iso_file_name}"
    unmount  = true # Unmount ISO after finishing.
  }
  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- ",
    "autoinstall ds='nocloud-net;s=http://${var.cloud_init_server_ip_address}:${var.cloud_init_server_port}/' <enter><wait3s>",
    "initrd /casper/initrd <enter><wait3s>",
    "boot <enter>",
  ]

  # These credentials must match what is defined within the "user-data" file in the "cloud-init" folder.
  ssh_username = var.vm_admin_username
  ssh_password = var.vm_admin_password
  ssh_timeout  = "30m"
}

build {
  sources = ["source.proxmox-iso.main"]
  provisioner "shell" {
    inline = [
      # Purge dependencies no longer needed.
      "sudo apt-get -y autoremove --purge",
      # Delete .deb files cached by apt.
      "sudo apt-get -y clean",
      # Remove the system's unique SSH keys.
      "sudo rm /etc/ssh/ssh_host_*",
      # Reduce the machine ID definition file to zero bytes.
      "sudo truncate -s 0 /etc/machine-id",
      # Reset the state of cloud-init so it can be ran again.
      "sudo cloud-init clean",
      # Commit all pending disk writes before shutting off the machine.
      "sudo sync",
    ]
  }
}
