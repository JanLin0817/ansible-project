# Terraform + Ansible Azure High Availability Infrastructure

This project provisions a high availability infrastructure on Microsoft Azure using Terraform, and configures the Linux VMs with Ansible. Terraform handles virtual networks, virtual machines (Linux and Windows), a load balancer, data disks, and common services like storage and logging. Ansible handles post-provisioning configuration (users, profiles, data disk formatting/mounting, web server setup).

## Project Structure

### Terraform modules

- **rgroup-n01742406**: Provisions the Resource Group.
- **network-n01742406**: Provisions the Virtual Network, Subnet, and Network Security Groups.
- **common-n01742406**: Provisions shared resources like Storage Accounts, Log Analytics Workspace, and Recovery Services Vault.
- **vmlinux-n01742406**: Provisions Linux Virtual Machines (CentOS) in an Availability Set with deterministic DNS labels.
- **vmwindows-n01742406**: Provisions Windows Virtual Machines in an Availability Set. (Ansible provisioning in this lab targets Linux nodes only.)
- **datadisk-n01742406**: Provisions and attaches managed data disks to the virtual machines.
- **loadbalancer-n01742406**: Provisions a Standard Load Balancer for the Linux VMs.
- **database-n01742406**: Provisions an Azure Database for PostgreSQL Flexible Server. *(currently disabled — see notes)*

### Ansible layout (`ansible/`)

- **`ansible.cfg`**: Points inventory to `./inventory` and roles to `./roles`. Auto-loaded when you run ansible commands from inside `ansible/`.
- **`inventory`**: Static inventory using Azure-assigned FQDNs (e.g. `n01742406-vm1.canadacentral.cloudapp.azure.com`). No `-i` flag needed when running from `ansible/`.
- **`inventory.tmpl`**: Terraform template for dynamically rendered inventory (alternative to the static file).
- **`n01742406-playbook.yml`**: Entry playbook — runs all roles against the `linux` group.
- **`roles/`**:
  - `profile-n01742406` — shell profile / environment setup
  - `user-n01742406` — user account management
  - `datadisk-n01742406` — format and mount the Terraform-attached data disks
  - `webserver-n01742406` — install and configure the web server

## Prerequisites

- Terraform v1.0+
- Ansible 2.12+ (Python 3.9 on the managed nodes)
- Azure CLI installed and authenticated
- SSH Key pair generated at `~/.ssh/id_rsa_azure` (or update variables in `modules/vmlinux-n01742406/variables.tf`)

## Usage

### 1. Provision infrastructure with Terraform

```bash
terraform init
terraform plan
terraform apply
```

The root `null_resource.ansible_provisioner` in `main.tf` automatically runs the Ansible playbook after the Linux VMs and data disks are ready.

### 2. Run Ansible manually (optional)

If you want to re-run Ansible without re-applying Terraform:

```bash
cd ansible/
ansible linux -m ping                      # sanity check
ansible-playbook n01742406-playbook.yml    # full provisioning
```

The `-i inventory` flag is not needed — `ansible.cfg` already points to it.

### Inventory notes

The static `inventory` uses Azure's deterministic FQDN format: `{vm-name}.{region}.cloudapp.azure.com`. These names come from `domain_name_label` in `modules/vmlinux-n01742406/main.tf:23` and are stable across `terraform apply` runs (unlike public IPs). If you change VM names, region, SSH user, or key path in Terraform variables, remember to update `inventory` to match — or switch to the dynamic `inventory.tmpl` rendered by Terraform.

## Outputs

The project outputs key information such as Resource Group Name, VM Hostnames/IPs, Load Balancer Name, and Database Name.

## TODO

- [ ] **Log Analytics Integration**: The Log Analytics Workspace is provisioned, and VM extensions (AzureMonitorLinuxAgent) are installed. However, Data Collection Rules (DCR) and full association are not yet configured.
- [ ] **Recovery Services Vault**: The resource is currently disabled (`count = 0`) in the common module. Needs to be enabled and configured for backups.
- [ ] **Database Module**: The PostgreSQL Flexible Server module is currently commented out in `main.tf` due to an `InternalServerError` during apply. Firewall rules and connectivity need to be revisited when re-enabled.
- [ ] **Load Balancer Health Probes**: Verify HTTP probe paths match the web server role's default configuration.
