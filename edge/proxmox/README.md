# Deploying a Kubernetes-Based DEATH Lab
These instructions assume you have the following software installed in a "Windows Subsystem for Linux (WSL)" environment.
| Software                             | Version    |
| ------------------------------------ | ---------- | 
| Proxmox                              | 8.2.2      |
| Packer                               | 1.14.1     |
| Terraform                            | 1.13.5     |
| Terraform `hashicorp/local` Provider | 2.6.1      |
| Terraform `telmate/proxmox` Provider | 3.0.2-rc05 |
| Ansible                              | 2.18.4     |

**Step 1.** Determine the IP address of your WSL environment. For example, my `eth0` in my WSL environment currently has an IP address of `172.19.27.181`. 

**Step 2.** Open an elevated Command Prompt window and enter the command below. Make sure to replace `172.19.27.181` with the IP address of your WSL environment. Do not close the elevated Command Prompt yet. 
```bash
netsh interface portproxy add v4tov4 listenport=8336 listenaddress=0.0.0.0 connectport=8336 connectaddress=172.19.27.181
```

**Step 3.** With the elevated Command Prompt still open, enter the command below. As before, make sure to replace `172.19.27.181` with the IP address of your WSL environment. You can close the elevated Command Prompt now. 
```bash
netsh advfirewall firewall add rule name="Packer" dir=in action=allow protocol=TCP localport=8336
```

**Step 4.** Download the latest versions of [Ubuntu](https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso) and [Proxmox](https://enterprise.proxmox.com/iso/proxmox-ve_9.1-1.iso),

**Step 5.** Install Proxmox on the machine you have designated to be your server. 

**Step 6.** Login to your Proxmox server using a browser on your Windows machine.

**Step 7.** Upload the copy of Ubuntu you downloaded to the local storage volume on your Proxmox server (tip: select "Folder View" if you can't find the local storage volume). 

**Step 8.** Create an API token for the `root` user (uncheck the "Privilege Separation" box). 

**Step 9.** In your WSL environment, clone this repository and change directories to `deathlabs/edge/proxmox`.
```bash
git clone git@github.com:deathlabs/deathlabs.git &&\
cd deathlabs/edge/proxmox
```

**Step 9.** Print your SSH public key to the terminal and then, copy it.
```bash
cat ~/.ssh/id_ed25519.pub 
```

**Step 10.** Paste your SSH public key to the `user-data` file in the provided `cloud-init` folder. Below is an example of how it should look afterwards.
```yaml
users:
- name: packer
    plain_text_passwd: packer
    lock-passwd: false
    groups: [adm, sudo]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
    - ssh-ed25519 AAA... jason@treadstone
```

**Step 11.** Create a file and name it `values.auto.pkvars.hcl` and add values similar to below. Replace `192.168.1.175` and `aaaaaaaa-bbbb-cccc-b952-eeeeeeeeeeee` with the IP address of your Proxmox server and the API key you generated. 
```bash
pm_api_url          = "https://192.168.1.175:8006/api2/json"
pm_api_token_id     = "root@pam!packer"
pm_api_token_secret = "aaaaaaaa-bbbb-cccc-b952-eeeeeeeeeeee"
vm_admin_username   = "packer" 
vm_admin_password   = "packer"
```

**Step 12.** Create a file and name it `values.auto.tfvars` and add values similar to below. 
```bash
# ------------------------------------------
# Proxmox
# ------------------------------------------
pm_api_url            = "https://192.168.1.175:8006/api2/json"
pm_api_token_id       = "root@pam!packer"
pm_api_token_secret   = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
pm_target_node_name   = "hypervisor-01"

# ------------------------------------------
# All nodes
# ------------------------------------------
vm_template_name      = "ubuntu-server-24.04"
gateway_ip_address    = "192.168.1.1"

# ------------------------------------------
# Controller node
# ------------------------------------------
controller_ip_address = "192.168.1.200"
```

**Step 12.** Text goes here.
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**Step 13.** Build the lab using the provided `Makefile`.
```bash
make build/lab
```

**Step 14.** Text goes here.
```bash
ansible-playbook -i inventory.yaml playbook.yaml
```

### References  
* [Packer: Input Variables and local variables](https://developer.hashicorp.com/packer/guides/hcl/variables#assigning-variables)
* [Cloud-Init: Data Sources - NoCloud](https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html)
* [phoenixNAP: How to Install Kubernetes on Ubuntu 22.04](https://phoenixnap.com/kb/install-kubernetes-on-ubuntu)
* [Terraform: Cloud Init Guide](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init)
