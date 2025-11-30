resource "local_file" "ansible_inventory_yaml" {
  content = yamlencode({
    "controller": {
      "hosts": {
        "${proxmox_vm_qemu.controller.default_ipv4_address}": ""
      }
    }
    "workers": {
      "hosts": {
        for name, worker in proxmox_vm_qemu.worker :
        worker.default_ipv4_address => ""
      }
    }
  })
  filename = "${path.module}/../ansible/inventory.yaml"
}
