packer {
  required_plugins {
    vmware = {
      source = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
    # commenting this out (currently developing Death Lab on Windows; Ansible is not Windows-friendly)
    #ansible = {
    #  source  = "github.com/hashicorp/ansible"
    #  version = "~> 1"
    #}
  }
}

source "vmware-iso" "workstation" {
  iso_url           = "iso-files/windows-11.iso"
  iso_checksum      = "sha256:36DE5ECB7A0DAA58DCE68C03B9465A543ED0F5498AA8AE60AB45FB7C8C4AE402"
  vm_name           = "Workstation"
  guest_os_type     = "windows9-64"
  cpus              = 2
  memory            = 8192
  disk_adapter_type = "ide"
  disk_size         = 65536
  floppy_files      = [
    "../init-files/autounattend.xml",
    "../scripts/Enable-WinRM.ps1",
  ]
  communicator      = "winrm"
  winrm_username    = "vagrant"
  winrm_password    = "vagrant" 
  shutdown_command  = "shutdown /s /t 000"
  output_directory  = "../virtual-machines/workstation"
}

source "vmware-iso" "domain-controller" {
  iso_url           = "iso-files/windows-server-2022.iso"
  iso_checksum      = "sha256:3E4FA6D8507B554856FC9CA6079CC402DF11A8B79344871669F0251535255325"
  vm_name           = "Domain-Controller"
  guest_os_type     = "windows2019srv_64"
  cpus              = 2
  memory            = 8192
  disk_adapter_type = "ide"
  disk_size         = 65536
  floppy_files      = [
    "configuration-files/Autounattend.xml",
    "scripts/Enable-WinRM.ps1",
  ]
  communicator      = "winrm"
  winrm_username    = "vagrant"
  winrm_password    = "vagrant" 
  shutdown_command  = "shutdown /s /t 000"
  output_directory  = "../virtual-machines/domain-controller"
}

source "vmware-iso" "event-collector" {
  iso_url           = "iso-files/windows-server-2022.iso"
  iso_checksum      = "sha256:3E4FA6D8507B554856FC9CA6079CC402DF11A8B79344871669F0251535255325"
  vm_name           = "Event-Collector"
  guest_os_type     = "windows2019srv_64"
  cpus              = 2
  memory            = 8192
  disk_adapter_type = "ide"
  disk_size         = 65536
  floppy_files      = [
    "configuration-files/Autounattend.xml",
    "scripts/Enable-WinRM.ps1",
  ]
  communicator      = "winrm"
  winrm_username    = "vagrant"
  winrm_password    = "vagrant" 
  shutdown_command  = "shutdown /s /t 000"
  output_directory  = "../virtual-machines/event-collector"
}

source "vmware-iso" "web-app" {
  iso_url           = "../iso-files/ubuntu-22.04.4-live-server-amd64.iso"
  iso_checksum      = "sha256:45F873DE9F8CB637345D6E66A583762730BBEA30277EF7B32C9C3BD6700A32B2"
  cpus              = "2"
  memory            = "4096"
  http_directory    = "../init-files/web-app/"
  boot_wait         = "10s"
  boot_command      = [
    "c",
    "<wait>",
    "linux /casper/vmlinuz --- autoinstall ",
    "ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter>",
    "<wait3s>initrd /casper/initrd <enter>",
    "<wait3s>boot <enter>",
  ]
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"
  shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
  output_directory  = "../virtual-machines/web-app"
}

source "vmware-iso" "velociraptor" {
  iso_url           = "../iso-files/CentOS-7-x86_64-Minimal-2009.iso"
  iso_checksum      = "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"
  cpus              = "2"
  memory            = "4096"
  http_directory    = "../init-files/velociraptor/"
  boot_wait         = "10s"
  boot_command      = [
    "<up><tab> ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
  ]
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"
  shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
  output_directory  = "../virtual-machines/velociraptor"
}

source "vmware-iso" "attacker" {
  iso_url           = "../iso-files/CentOS-7-x86_64-Minimal-2009.iso"
  iso_checksum      = "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"
  cpus              = "2"
  memory            = "4096"
  http_directory    = "../init-files/attacker/"
  boot_wait         = "10s"
  boot_command      = [
    "<up><tab> ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
  ]
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"
  shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
  output_directory  = "../virtual-machines/attacker"
}

build {
  sources                = [
    "source.vmware-iso.web-app",
    #"source.vmware-iso.domain-controller",
    #"source.vmware-iso.event-collector",
    #"source.vmware-iso.attacker",
    #"source.vmware-iso.velociraptor"
  ]

  # commenting this out (currently developing Death Lab on Windows; Ansible is not Windows-friendly)
  #provisioner "ansible" {
  #  playbook_file          = "../ansible/playbook.yaml"
  #  extra_arguments = [
  #    "--scp-extra-args", "'-O'"
  #  ]
  #}

  post-processor "vagrant" {
    only   = ["vmware-iso.web-app"]
    keep_input_artifact  = false
    output               = "../vagrant/boxes/web-app.box"
  }

  #post-processor "vagrant" {
  #  only   = ["vmware-iso.velociraptor"]
  #  keep_input_artifact  = false
  #  output               = "../vagrant/boxes/velociraptor.box"
  #}
}