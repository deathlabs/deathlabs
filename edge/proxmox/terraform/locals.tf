locals {
  controller_ids = {
    for controller_id in range(var.controller_count):
      tostring(controller_id) => controller_id
  }

  worker_ids = {
    for worker_id in range(var.worker_count):
      tostring(worker_id) => worker_id
  }

  base_octets = slice(split(".", var.controller_ip_address), 0, 3)
  base_host   = tonumber(regex("(\\d+)$", var.controller_ip_address)[0])

  controller_ip_addresses = {
    for controller_id in keys(local.controller_ids):
      local.controller_ids[controller_id] => format(
        "%s.%s.%s.%d",
        local.base_octets[0],
        local.base_octets[1],
        local.base_octets[2],
        local.base_host + local.controller_ids[controller_id]
      )
  }

  worker_ip_addresses = {
    for worker_id in keys(local.worker_ids):
      local.worker_ids[worker_id] => format(
        "%s.%s.%s.%d",
        local.base_octets[0],
        local.base_octets[1],
        local.base_octets[2],
        local.base_host + var.controller_count + local.worker_ids[worker_id] + 1
      )
  }

  controller_vmid_map = {
    for controller_id in keys(local.controller_ids):
      local.controller_ids[controller_id] => var.controller_vm_id + local.controller_ids[controller_id]
  }

  worker_vmid_map = {
    for worker_id in keys(local.worker_ids):
      local.worker_ids[worker_id] => var.controller_vm_id + var.controller_count + local.worker_ids[worker_id] + 1
  }
}
