# ---------------------------------------------------------
# Build the virtual machine template.
# ---------------------------------------------------------

.PHONY: build/template
.SILENT: build/template

build/template: 
	cd packer &&\
	packer init . &&\
	packer validate . &&\
	packer build . &&\
	cd ..
 
# ---------------------------------------------------------
# Build the virtual machine nodes.
# ---------------------------------------------------------

.PHONY: build/nodes
.SILENT: build/nodes

build/nodes: 
	terraform -chdir=terraform init &&\
	terraform -chdir=terraform apply -auto-approve

# ---------------------------------------------------------
# Configure the virtual machine nodes.
# ---------------------------------------------------------

.PHONY: configure/nodes
.SILENT: configure/nodes

configure/nodes:
	ansible-playbook -i ansible/inventory.yaml --ssh-extra-args='-o StrictHostKeyChecking=no' ansible/playbook.yaml

# ---------------------------------------------------------
# Build the entire lab.
# ---------------------------------------------------------

.PHONY: build/lab
.SILENT: build/lab

build/lab: build/template build/nodes configure/nodes

# ---------------------------------------------------------
# Destroy the virtual machine template.
# ---------------------------------------------------------

.PHONY: destroy/template
.SILENT: destroy/template

destroy/template: 
	ssh -o StrictHostKeyChecking=no -T root@192.168.1.175 'qm destroy 100'

# ---------------------------------------------------------
# Destroy the local Terraform state.
# ---------------------------------------------------------

.PHONY: destroy/state
.SILENT: destroy/state

destroy/state: 
	rm -rf terraform/terraform.tfstate* &&\
	rm -rf terraform/.terraform*

# ---------------------------------------------------------
# Destroy the virtual machine nodes.
# ---------------------------------------------------------

.PHONY: destroy/nodes
.SILENT: destroy/nodes

destroy/nodes: 
	terraform -chdir=terraform destroy

# ---------------------------------------------------------
# Destroy the Ansible inventory.
# ---------------------------------------------------------

.PHONY: destroy/inventory
.SILENT: destroy/inventory

destroy/inventory: 
	rm ansible/inventory.yaml

# ---------------------------------------------------------
# Destroy the entire lab.
# ---------------------------------------------------------

.PHONY: destroy/lab
.SILENT: destroy/lab

destroy/lab: destroy/nodes destroy/inventory destroy/template destroy/state 
