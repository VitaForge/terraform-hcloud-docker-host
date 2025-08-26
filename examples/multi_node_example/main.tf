terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

module "hcloud-docker-hosts" {
  source = "../../"
  
  ssh_public_key = var.ssh_public_key
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
}
