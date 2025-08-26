variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key for server access"
}
