# Production Docker Swarm Cluster Example

This example demonstrates how to provision a production-ready Docker Swarm cluster using the `terraform-hcloud-docker-host` module.

## Architecture

The production cluster consists of:

- **3 Manager Nodes** (cx31 instances, 50GB volumes, with backups)

  - `swarm-manager-1` - Nuremberg (nbg1)
  - `swarm-manager-2` - Frankfurt (fsn1)
  - `swarm-manager-3` - Helsinki (hel1)

- **4 Worker Nodes** (cx21 instances, 30GB volumes, no backups)
  - `swarm-worker-1` - Nuremberg (nbg1)
  - `swarm-worker-2` - Frankfurt (fsn1)
  - `swarm-worker-3` - Helsinki (hel1)
  - `swarm-worker-4` - Nuremberg (nbg1)

## Features

- **High Availability**: Multiple manager nodes across different locations
- **Load Distribution**: Worker nodes distributed across locations
- **Backup Strategy**: Manager nodes have backups enabled
- **Scalable**: Easy to add more worker nodes
- **Multi-location**: Servers spread across different Hetzner Cloud locations

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

## Post-Provisioning

After the servers are provisioned, you'll need to:

1. **Initialize Docker Swarm** on the first manager:

   ```bash
   ssh root@<swarm-manager-1-ip>
   docker swarm init --advertise-addr <swarm-manager-1-ip>
   ```

2. **Join other managers** to the swarm:

   ```bash
   # Get the join token for managers
   docker swarm join-token manager

   # On each manager node
   ssh root@<manager-ip>
   docker swarm join --token <manager-token> <swarm-manager-1-ip>:2377
   ```

3. **Join worker nodes** to the swarm:

   ```bash
   # Get the join token for workers
   docker swarm join-token worker

   # On each worker node
   ssh root@<worker-ip>
   docker swarm join --token <worker-token> <swarm-manager-1-ip>:2377
   ```

## Outputs

- `cluster_info`: Summary of total nodes, managers, and workers
- `manager_nodes`: Detailed information about manager nodes
- `worker_nodes`: Detailed information about worker nodes
- `manager_ips`: IPv4 addresses of manager nodes
- `worker_ips`: IPv4 addresses of worker nodes
- `all_server_ips`: All server names mapped to IP addresses
- `primary_manager`: Information about the primary manager node

## Cost Optimization

- Manager nodes use cx31 (larger instances) for swarm management
- Worker nodes use cx21 (smaller instances) for running containers
- Backups only enabled on manager nodes
- Consider using different server types based on your workload requirements

## Scaling

To add more nodes, simply add entries to the `servers` list in `main.tf`:

```hcl
{
  name        = "swarm-worker-5"
  server_type = "cx21"
  image       = "ubuntu-24.04"
  location    = "nbg1"
  backups     = false
  volume_size = 30
}
```
