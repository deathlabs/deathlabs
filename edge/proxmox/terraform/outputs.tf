resource "local_file" "ansible_inventory_yaml" {
  content = yamlencode({
    controllers = {
      hosts = {
        for controller_id, controller in proxmox_vm_qemu.controller:
          local.controller_ip_addresses[tonumber(controller_id)] => ""
      }
    }
    workers = {
      hosts = {
        for worker_id, worker in proxmox_vm_qemu.worker:
          local.worker_ip_addresses[tonumber(worker_id)] => ""
      }
    }
  })
  filename = "${path.module}/../ansible/inventory.yaml"
}
