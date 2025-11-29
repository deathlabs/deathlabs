locals {
  # Get the last octet of the controller IP address.
  controller_host = tonumber(regex("(\\d+)$", var.controller_ip_address)[0])

  # Turn work counter into a range of numbers.
  worker_ids = range(var.worker_count)

  # Generate IP addresses for each worker based on the controller's IP address.
  worker_ip_addresses = [
    for worker_id in local.worker_ids :
    format(
      "%s.%s.%s.%d",
      split(".", var.controller_ip_address)[0],
      split(".", var.controller_ip_address)[1],
      split(".", var.controller_ip_address)[2],
      local.controller_host + worker_id + 1
    )
  ]
}
