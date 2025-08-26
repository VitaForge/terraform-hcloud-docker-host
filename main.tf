resource "hcloud_ssh_key" "default" {
  name       = var.ssh_public_key_name
  public_key = var.ssh_public_key
}

resource "hcloud_volume" "volumes" {
  for_each = { for idx, server in var.servers : server.name => server }
  
  name      = "docker_data_volume_${each.value.name}"
  size      = each.value.volume_size
  location  = each.value.location
  automount = false
  format    = var.volume_filesystem
}

resource "hcloud_server" "servers" {
  for_each = { for idx, server in var.servers : server.name => server }
  
  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = each.value.location
  backups     = each.value.backups
  ssh_keys    = [var.ssh_public_key_name]
  user_data = templatefile("${path.module}/user_data/${each.value.image}.yaml", {
    docker_compose_version = var.docker_compose_version
    volume_filesystem      = var.volume_filesystem
    filesystem_cmd_opt     = var.volume_filesystem == "xfs" ? "-f" : "-F"
    linux_device           = hcloud_volume.volumes[each.key].linux_device
    mount_dir_name         = hcloud_volume.volumes[each.key].name
    is_first_node          = each.key == keys(var.servers)[0]
    manager_ip             = each.key == keys(var.servers)[0] ? "" : hcloud_server.servers[keys(var.servers)[0]].ipv4_address
  })
}

resource "hcloud_volume_attachment" "attachments" {
  for_each = { for idx, server in var.servers : server.name => server }
  
  volume_id = hcloud_volume.volumes[each.key].id
  server_id = hcloud_server.servers[each.key].id
  automount = true
}