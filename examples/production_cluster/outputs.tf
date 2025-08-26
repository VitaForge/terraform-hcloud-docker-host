output "cluster_info" {
  description = "Complete information about the Docker Swarm cluster"
  value = {
    total_nodes = module.docker_swarm_cluster.server_count
    managers    = length([for name, server in module.docker_swarm_cluster.servers : server if can(regex("^swarm-manager-", name))])
    workers     = length([for name, server in module.docker_swarm_cluster.servers : server if can(regex("^swarm-worker-", name))])
  }
}

output "manager_nodes" {
  description = "Information about manager nodes only"
  value = {
    for name, server in module.docker_swarm_cluster.servers : name => server
    if can(regex("^swarm-manager-", name))
  }
}

output "worker_nodes" {
  description = "Information about worker nodes only"
  value = {
    for name, server in module.docker_swarm_cluster.servers : name => server
    if can(regex("^swarm-worker-", name))
  }
}

output "manager_ips" {
  description = "IPv4 addresses of manager nodes"
  value = {
    for name, server in module.docker_swarm_cluster.servers : name => server.ipv4_address
    if can(regex("^swarm-manager-", name))
  }
}

output "worker_ips" {
  description = "IPv4 addresses of worker nodes"
  value = {
    for name, server in module.docker_swarm_cluster.servers : name => server.ipv4_address
    if can(regex("^swarm-worker-", name))
  }
}

output "all_server_ips" {
  description = "Map of all server names to their IPv4 addresses"
  value = module.docker_swarm_cluster.server_ips
}

output "primary_manager" {
  description = "Information about the primary manager node"
  value = module.docker_swarm_cluster.servers["swarm-manager-1"]
}
