# terraform-hcloud-docker-host

A Terraform module to deploy Docker hosts (in swarm mode) on Hetzner Cloud. The module supports both single and multi-node deployments. A separate Hetzner Cloud volume is created for each server, attached and configured as the Docker root directory. See the variables file for the available configuration settings.

The resources/services/activations/deletions that this module will create/trigger are:

- Create one or more servers and cloud volumes on the Hetzner Cloud Platform
- Create or use an existing SSH Public Key
- Install Docker Compose, Docker and enable Docker Swarm mode on each server

## Features

- **Single Node**: Deploy a single Docker host (backward compatible)
- **Multi Node**: Deploy multiple Docker hosts with different configurations
- **Flexible Configuration**: Each server can have different specs, locations, and volume sizes
- **Scalable Architecture**: Easy to add or remove nodes as needed

## Tutorial

[Provision a Docker Swarm Host with Traefik (v2) on Hetzner Cloud using Terraform Modules - Part 1](https://colinwilson.uk/2020/10/31/provision-a-docker-swarm-host-with-traefik-v2-on-hetzner-cloud-using-terraform-modules-part-1)

## Compatibility

This module is meant for use with Terraform 0.13 or higher.

## Usage

### Single Node (Legacy)

Basic usage for a single Docker host:

```hcl
module "hcloud-docker-host" {
  source  = "github.com/colinwilson/terraform-hcloud-docker-host"
  version = "~> 0.1.4"

  server               = {
    name               = "docker-swarm-host-01"
    server_type        = "cx11"
    image              = "ubuntu-20.04"
    location           = "hel1"
    backups            = false
  }
  ssh_public_key_name = "my_ssh_key"
  ssh_public_key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNcwP5mhs5/F2T9GFHmg4z6E6sbOG+Ynx2iPERKeOGm"
  volume_size         = 20
  volume_filesystem   = "xfs"
}
```

### Multi Node (Recommended)

Deploy multiple Docker hosts with different configurations:

```hcl
module "hcloud-docker-hosts" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"

  ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNcwP5mhs5/F2T9GFHmg4z6E6sbOG+Ynx2iPERKeOGm"
  servers = [
    {
      name        = "docker-master"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = true
      volume_size = 20
    },
    {
      name        = "docker-worker-1"
      server_type = "cx11"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = false
      volume_size = 15
    },
    {
      name        = "docker-worker-2"
      server_type = "cx11"
      image       = "ubuntu-24.04"
      location    = "frankfurt"
      backups     = false
      volume_size = 15
    }
  ]
  volume_filesystem = "xfs"
}
```

Functional examples are included in the [examples](./examples/) directory:

- [simple_example](./examples/simple_example/) - Single node deployment
- [multi_node_example](./examples/multi_node_example/) - Multi-node deployment

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

### Required

| Name           | Description     |  Type  | Default | Required |
| -------------- | --------------- | :----: | :-----: | :------: |
| ssh_public_key | SSH Public Key. | string |   n/a   |   yes    |

### Optional

| Name                   | Description                        |     Type     |                                                                       Default                                                                        | Required |
| ---------------------- | ---------------------------------- | :----------: | :--------------------------------------------------------------------------------------------------------------------------------------------------: | :------: |
| servers                | List of server configurations.     | list(object) | <code lang="hcl">[{name = "docker-host", server_type = "cx11", image = "ubuntu-22.04", location = "nbg1", backups = false, volume_size = 10}]</code> |    no    |
| docker_compose_version | Docker compose version to install. |    string    |                                                                      `"2.17.3"`                                                                      |    no    |
| volume_filesystem      | Volume filesystem.                 |    string    |                                                                       `"xfs"`                                                                        |    no    |
| ssh_public_key_name    | SSH Public Key Name.               |    string    |                                                                     `"default"`                                                                      |    no    |

**Note**: The `server` and `volume_size` variables are deprecated. Use `servers[].volume_size` instead.

## Outputs

| Name               | Description                                         |
| ------------------ | --------------------------------------------------- |
| servers            | Complete information about all provisioned servers. |
| server_ips         | Map of server names to their IPv4 addresses.        |
| server_count       | Total number of provisioned servers.                |
| ipv4_address       | First server's public IPv4 address (deprecated).    |
| volume_size        | First server's volume size (deprecated).            |
| volume_mount_point | First server's volume mount point (deprecated).     |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform](https://www.terraform.io/downloads.html) v0.13
- [Terraform Provider for Hetzner Cloud](https://registry.terraform.io/providers/hetznercloud/hcloud/latest) version v1.2.x

### Hetzner Cloud Account

A [Hetzner Cloud account](https://accounts.hetzner.com/signUp) and [API Token](https://colinwilson.uk/2020/10/31/generate-an-api-token-in-hetzner-cloud/) (with Read & Write permissions) to provision
the resources of this module.
