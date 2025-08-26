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

module "hcloud-docker-host" {
  source = "github.com/colinwilson/terraform-hcloud-docker-host"
  
  ssh_public_key = var.ssh_public_key
  servers = [
    {
      name        = "docker-host"
      server_type = "cx11"
      image       = "ubuntu-22.04"
      location    = "nbg1"
      backups     = false
      volume_size = 10
    }
  ]
}
