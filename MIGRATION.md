# Migration Guide

This guide helps you migrate from the old single-node configuration to the new multi-node configuration.

## What Changed

### Variables

- **Old**: `server` (map) and `volume_size` (number)
- **New**: `servers` (list of objects with embedded volume_size)

### Resources

- **Old**: Single server, volume, and attachment
- **New**: Multiple servers, volumes, and attachments using `for_each`

### Outputs

- **Old**: Single values for IP, volume size, and mount point
- **New**: Maps and lists containing information for all servers

## Migration Steps

### 1. Update Your Variables

**Before (old way):**

```hcl
variable "server" {
  type = map(any)
  default = {
    name        = "docker-host"
    server_type = "cx11"
    image       = "ubuntu-22.04"
    location    = "nbg1"
    backups     = false
  }
}

variable "volume_size" {
  type    = number
  default = 20
}
```

**After (new way):**

```hcl
variable "servers" {
  type = list(object({
    name        = string
    server_type = string
    image       = string
    location    = string
    backups     = bool
    volume_size = optional(number, 10)
  }))
  default = [
    {
      name        = "docker-host"
      server_type = "cx11"
      image       = "ubuntu-22.04"
      location    = "nbg1"
      backups     = false
      volume_size = 20
    }
  ]
}
```

### 2. Update Your Module Call

**Before (old way):**

```hcl
module "hcloud-docker-host" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"

  server        = var.server
  volume_size   = var.volume_size
  ssh_public_key = var.ssh_public_key
}
```

**After (new way):**

```hcl
module "hcloud-docker-host" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"

  servers        = var.servers
  ssh_public_key = var.ssh_public_key
}
```

### 3. Update Your Outputs

**Before (old way):**

```hcl
output "server_ip" {
  value = module.hcloud-docker-host.ipv4_address
}

output "volume_size" {
  value = module.hcloud-docker-host.volume_size
}
```

**After (new way):**

```hcl
output "server_ips" {
  value = module.hcloud-docker-host.server_ips
}

output "all_servers" {
  value = module.hcloud-docker-host.servers
}
```

## Example Migration

### Single Node to Multi-Node

**Before:**

```hcl
module "docker-host" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"

  server = {
    name        = "my-docker-host"
    server_type = "cx21"
    image       = "ubuntu-24.04"
    location    = "nbg1"
    backups     = true
  }
  volume_size = 50
  ssh_public_key = var.ssh_key
}
```

**After:**

```hcl
module "docker-hosts" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"

  servers = [
    {
      name        = "my-docker-host"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = true
      volume_size = 50
    }
  ]
  ssh_public_key = var.ssh_key
}
```

### Adding More Nodes

To add more nodes, simply add entries to the `servers` list:

```hcl
servers = [
  {
    name        = "my-docker-host"
    server_type = "cx21"
    image       = "ubuntu-24.04"
    location    = "nbg1"
    backups     = true
    volume_size = 50
  },
  {
    name        = "my-docker-worker"
    server_type = "cx11"
    image       = "ubuntu-24.04"
    location    = "fsn1"
    backups     = false
    volume_size = 30
  }
]
```

## Backward Compatibility

The old variables (`server` and `volume_size`) are still available but deprecated. They will show deprecation warnings and eventually be removed in a future version.

The old outputs (`ipv4_address`, `volume_size`, `volume_mount_point`) are still available for backward compatibility but will only show information for the first server.

## Testing Migration

1. **Backup your current state:**

   ```bash
   terraform state pull > backup.tfstate
   ```

2. **Update your configuration** following the steps above

3. **Plan the changes:**

   ```bash
   terraform plan
   ```

4. **Review the plan** to ensure no unexpected changes

5. **Apply the changes:**
   ```bash
   terraform apply
   ```

## Need Help?

- Check the [examples](./examples/) directory for working configurations
- Review the [README](./README.md) for updated documentation
- Open an issue on GitHub if you encounter problems
