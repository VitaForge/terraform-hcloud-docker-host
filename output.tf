output "servers" {
  description = "Map of all provisioned servers with their details"
  value = {
    for name, server in hcloud_server.servers : name => {
      id           = server.id
      name         = server.name
      ipv4_address = server.ipv4_address
      ipv6_address = server.ipv6_address
      status       = server.status
      server_type  = server.server_type
      location     = server.location
      image        = server.image
      volume_id    = hcloud_volume.volumes[name].id
      volume_size  = hcloud_volume.volumes[name].size
      volume_mount = hcloud_volume.volumes[name].linux_device
    }
  }
}

output "server_ips" {
  description = "Map of server names to their IPv4 addresses"
  value = {
    for name, server in hcloud_server.servers : name => server.ipv4_address
  }
}

output "server_count" {
  description = "Total number of provisioned servers"
  value = length(var.servers)
}

output "first_server_ip" {
  description = "IPv4 address of the first server (for swarm initialization)"
  value = length(var.servers) > 0 ? hcloud_server.servers[keys(hcloud_server.servers)[0]].ipv4_address : null
}