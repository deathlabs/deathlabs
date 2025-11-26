output "bastion_username" {
  value = var.bastion_username
}

output "bastion_ip_address" {
  value = module.network.bastion_ip_address
}

resource "local_file" "main" {
  content  = yamlencode({
    "attacker": {
      "hosts": {
        "${module.network.attacker_ip_address}": ""
      }
    }
    "dc": {
      "hosts": {
        "${module.network.dc_ip_address}": ""
      }
    }
    "wec": {
      "hosts": {
        "${module.network.wec_ip_address}": ""
      }
    }
    "velociraptor": {
      "hosts": {
        "${module.network.velociraptor_ip_address}": ""
      }
    }
    "user": {
      "hosts": {
        "${module.network.user_ip_address}": ""
      }
    }
  })
  filename = "${path.module}/../ansible/inventory.yaml"
}