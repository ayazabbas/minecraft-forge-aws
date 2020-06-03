variable "allowed_user_ips" {
  type        = list
  description = "List of IP addresses in cidr format e.g. '75.99.181.44/32,97.1.193.55/32'"
}

variable "allowed_admin_ips" {
  type        = list
  description = "List of IP addresses in cidr format e.g. '75.99.181.44/32,97.1.193.55/32'"
}

variable "region" {
  type        = string
  description = "Region to launch resources in."
}
