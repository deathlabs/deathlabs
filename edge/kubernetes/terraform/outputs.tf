output "controller_ip_address" {
  description = "Controll IP address"
  value       = proxmox_vm_qemu.controller.default_ipv4_address
}

output "worker_ip_addresses" {
  description = "Worker names and IP addresses"
  value = {
    for name, worker in proxmox_vm_qemu.worker :
    name => worker.default_ipv4_address
  }
}

output "ansible_inventory" {
  description = "An Ansible-friendly inventory file with node information"
  value = <<EOF
[controller]
${proxmox_vm_qemu.controller.default_ipv4_address}

[workers]
%{ for name, worker in proxmox_vm_qemu.worker ~}
${worker.default_ipv4_address} ansible_host=${worker.default_ipv4_address} node_name=${name}
%{ endfor ~}
EOF
}
