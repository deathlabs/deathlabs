# ---------------------------------------------------------
# Build the virtual machine template using Packer.
# ---------------------------------------------------------

.PHONY: build/template
.SILENT: build/template

build/template: 
	python -m http.server 8336 -d cloud-init &
	packer init .
	packer validate .
	packer build .

# ---------------------------------------------------------
# Build the virtual machine nodes using Terraform.
# ---------------------------------------------------------

.PHONY: build/nodes
.SILENT: build/nodes

build/nodes: 
	terraform -chdir=terraform init
	terraform -chdir=terraform apply -auto-approve

# ---------------------------------------------------------
# Destroy the virtual machine nodes using Terraform.
# ---------------------------------------------------------

.PHONY: destroy/nodes
.SILENT: destroy/nodes

destroy/nodes: 
	terraform -chdir=terraform destroy
