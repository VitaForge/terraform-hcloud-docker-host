# Multi-Node Docker Hosts Example

This example demonstrates how to provision multiple Docker hosts using the updated `terraform-hcloud-docker-host` module.

## Features

- **Multiple servers**: Provision any number of Docker hosts
- **Different configurations**: Each server can have different specs, locations, and volume sizes
- **Flexible deployment**: Mix and match server types, locations, and backup policies
- **Scalable architecture**: Easy to add or remove nodes as needed

## Configuration

The example provisions three servers:

1. **docker-master** (cx21, 20GB volume, with backups)
2. **docker-worker-1** (cx11, 15GB volume, no backups)
3. **docker-worker-2** (cx11, 15GB volume, no backups, different location)

## Usage

1. Set your Hetzner Cloud API token:

   ```bash
   export TF_VAR_hcloud_token="your-api-token-here"
   ```

2. Set your SSH public key:

   ```bash
   export TF_VAR_ssh_public_key="ssh-rsa AAAA..."
   ```

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Outputs

- `all_servers`: Complete information about all servers
- `server_ips`: Map of server names to IP addresses
- `master_server_ip`: IP address of the master server
- `worker_servers`: Information about worker servers only
- `total_servers`: Total count of provisioned servers

## Customization

Modify the `servers` list in `main.tf` to:

- Change server types (cx11, cx21, cx31, etc.)
- Adjust volume sizes (10GB to 10TB)
- Use different locations (nbg1, fsn1, hel1, etc.)
- Enable/disable backups per server
- Use different OS images
