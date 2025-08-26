# Required configuration
variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key"
}

# Server configuration
variable "servers" {
  type = list(object({
    name        = string
    server_type = string
    image       = string
    location    = string
    backups     = bool
    volume_size = optional(number, 10)
  }))
  description = "List of server configurations"
  default = [
    {
      name        = "docker-host"
      server_type = "cx11"
      image       = "ubuntu-22.04"
      location    = "nbg1"
      backups     = false
      volume_size = 10
    }
  ]
  validation {
    condition = alltrue([
      for server in var.servers : 
      server.volume_size >= 10 && server.volume_size <= 10240
    ])
    error_message = "Volume size must be between 10 and 10240 GB for all servers."
  }
}

variable "docker_compose_version" {
  type        = string
  description = "Docker compose version to install"
  default     = "2.17.3" # https://github.com/docker/compose/releases/latest
}

variable "volume_filesystem" {
  type        = string
  description = "Volume filesystem"
  default     = "xfs" # https://docs.hetzner.cloud/#volumes-create-a-volume
  validation {
    condition     = length(regexall("^ext4|xfs$", var.volume_filesystem)) > 0
    error_message = "Invalid volume filesystem type value. Valid filesystem types are ext4 or xfs."
  }
}

variable "ssh_public_key_name" {
  type        = string
  description = "SSH Public Key Name"
  default     = "default"
}
