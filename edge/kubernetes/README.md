# Deploying a Kubernetes-Based DEATH Lab
These instructions assume you have Packer, Ansible, and Terraform installed.

**Step 1.** On your host machine, download the latest Ubuntu server image (e.g., [Ubuntu 24.04](https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso)).

**Step 2.** Install Proxmox. 

**Step 3.** Login to your Proxmox server using a browser.

**Step 4.** Upload a copy of the latest Ubuntu image to the local storage volume on your Proxmox server (tip: select "Folder View" if you can't where the local storage volume). 

**Step 5.** Create an API token for the `root` user (uncheck the "Privilege Separation" box). 

**Step 6.** Determine the IP address of your WSL environment. For example, my `eth0` in my WSL environment currently has an IP address of `172.19.27.181`. 

**Step 7.** Open an elevated Command Prompt and enter the command below. Make sure to replace `172.19.27.181` with the IP address of your WSL environment. Do not close the elevated Command Prompt yet. 
```bash
netsh interface portproxy add v4tov4 listenport=8336 listenaddress=0.0.0.0 connectport=8336 connectaddress=172.19.27.181
```

**Step 8.** With the elevated Command Prompt still open, enter the command below. As before, make sure to replace `172.19.27.181` with the IP address of your WSL environment. You can close the elevated Command Prompt now. 
```bash
netsh advfirewall firewall add rule name="Packer" dir=in action=allow protocol=TCP localport=8336
```

**Step 9.** Print your SSH public key to the terminal and then, copy it to memory.
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
    - ssh-ed25519 AAA... victor@computer
```

**Step 11.** Enter the command below to invoke a Python-based HTTP server that will serve the files in the `cloud-init` folder. Before moving forward, make sure you can browse to this TCP port. If this TCP port is not accessible, the provisioning process will hang and your build will exceed the SSH time limit.
```bash
python -m http.server 8336 -d cloud-init
```

**Step 12.** Change directories to the `packer` folder.
```bash
cd packer/
```

**Step 13.** Create a file and name it `values.auto.pkvars.hcl` and add values similar to below (use the API key you generated). 
```bash
pm_api_url          = "https://192.168.1.175:8006/api2/json"
pm_api_token_id     = "root@pam!packer"
pm_api_token_secret = "aaaaaaaa-bbbb-cccc-b952-eeeeeeeeeeee"
vm_admin_username   = "packer" 
vm_admin_password   = "packer"
```

**Step 14.** Initialize the `packer` directory for Packer-use.
```bash
packer init .
```

**Step 15.** Validate your Packer configuration.
```bash
packer validate .
```

You should get output similar to below. 
```
The configuration is valid.
```

**Step 16.** Run the command below. This took about 14 minutes to complete.
```bash
packer build .
```

**Step 17.** Change directories to the `terraform` folder.
```bash
cd ../terraform/
```

**Step 18.** Create a file and name it `values.auto.tfvars`. Then, add values similar to below. 
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

**Step 19.** Initialize the `terraform` directory.
```bash
terraform init 
```

**Step 20.** Run the command below. This will use VM template `100` and make VMs `200`, `201`, and `202`. This took about 3 and half minutes.
```bash
terraform apply
```

### References  
* [Packer: Input Variables and local variables](https://developer.hashicorp.com/packer/guides/hcl/variables#assigning-variables)
* [Cloud-Init: Data Sources - NoCloud](https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html)
* [phoenixNAP: How to Install Kubernetes on Ubuntu 22.04](https://phoenixnap.com/kb/install-kubernetes-on-ubuntu)
* [Terraform: Cloud Init Guide](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init)
