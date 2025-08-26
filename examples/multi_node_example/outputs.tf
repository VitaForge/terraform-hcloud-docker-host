output "all_servers" {
  description = "Complete information about all provisioned servers"
  value       = module.hcloud-docker-hosts.servers
}

output "server_ips" {
  description = "Map of server names to their IPv4 addresses"
  value       = module.hcloud-docker-hosts.server_ips
}

output "master_server_ip" {
  description = "IPv4 address of the master server"
  value       = module.hcloud-docker-hosts.servers["docker-master"].ipv4_address
}

output "worker_servers" {
  description = "Information about worker servers only"
  value = {
    for name, server in module.hcloud-docker-hosts.servers : name => server
    if can(regex("^docker-worker-", name))
  }
}

output "total_servers" {
  description = "Total number of provisioned servers"
  value = module.hcloud-docker-hosts.server_count
}
