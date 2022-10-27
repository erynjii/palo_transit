variable location {
}

variable resource_group_name {
}

variable subnet_mgmt {
}

variable subnet_untrust {
}

variable subnet_trust {
}

variable avset_name {
}

variable avset_fault_domain_count {
  default = 2
}

variable panos {
}

variable license {
}

variable username {
}

variable password {
}

variable name {
  default = "vmseries"
}

variable nsg_prefix {
  description = "Enter a valid address prefix.  This address prefix will be able to access the firewalls mgmt interface over TCP/443 and TCP/22"
  default     = "65.204.57.64/26,65.204.10.128/26,100.37.140.70/32,172.27.128.0/18,73.56.114.10,136.52.78.58"
}

variable vm_count {
}

variable size {
  default = "Standard_DS3_v2"
}

variable sku {
  default = "Standard"
}

variable public_ip_address_allocation {
  default = "Static"
}

variable bootstrap_storage_account {
  default = ""
}

variable bootstrap_access_key {
  default = ""
}

variable bootstrap_file_share {
  default = ""
}

variable bootstrap_share_directory {
  default = "None"
}

variable nic0_public_ip {
  type    = bool
  default = false
}

variable nic1_public_ip {
  type    = bool
  default = false
}

variable nic2_public_ip {
  default = null
}

variable nic1_backend_pool_id {
  type    = list(string)
  default = []
}

variable nic2_backend_pool_id {
  type    = list(string)
  default = []
}

variable delete_disk_on_termination {
  type    = bool
  default = false
}
