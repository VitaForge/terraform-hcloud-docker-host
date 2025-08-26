terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  
  required_version = ">= 1.0"
}

provider "hcloud" {
  token = var.hcloud_token
}

# Production Docker Swarm Cluster
module "docker_swarm_cluster" {
  source = "../../"
  
  ssh_public_key = var.ssh_public_key
  servers = [
    # Manager nodes (larger instances for swarm management)
    {
      name        = "swarm-manager-1"
      server_type = "cx31"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = true
      volume_size = 50
    },
    {
      name        = "swarm-manager-2"
      server_type = "cx31"
      image       = "ubuntu-24.04"
      location    = "fsn1"
      backups     = true
      volume_size = 50
    },
    {
      name        = "swarm-manager-3"
      server_type = "cx31"
      image       = "ubuntu-24.04"
      location    = "hel1"
      backups     = true
      volume_size = 50
    },
    
    # Worker nodes (smaller instances for running containers)
    {
      name        = "swarm-worker-1"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = false
      volume_size = 30
    },
    {
      name        = "swarm-worker-2"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "fsn1"
      backups     = false
      volume_size = 30
    },
    {
      name        = "swarm-worker-3"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "hel1"
      backups     = false
      volume_size = 30
    },
    {
      name        = "swarm-worker-4"
      server_type = "cx21"
      image       = "ubuntu-24.04"
      location    = "nbg1"
      backups     = false
      volume_size = 30
    }
  ]
  
  volume_filesystem = "xfs"
  docker_compose_version = "2.24.0"
}
