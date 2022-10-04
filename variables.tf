variable "resource_group_name" {
  description = "Resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}

variable "virtual_network_name" {
  description = "Virtual network name"
  default     = "logscaleVNET"
}

variable "virtual_network_address_prefix" {
  description = "logscale VNET address prefix"
  default     = "10.1.0.0/16"
}

variable "aks_subnet_name" {
  description = "logscale"
  default     = "kubesubnet"
}

variable "aks_subnet_address_prefix" {
  description = "Subnet address prefix."
  default     = "10.1.0.0/20"
}


variable "aks_name" {
  description = "AKS cluster name"
  default     = "aks-logscale"
}

variable "aks_enable_ultra_disks" {
  description = "AKS cluster name"
  default     = false
}

variable "aks_admin_group_id" {
  type        = string
  description = "Azure AD Group IDs granted admin role"
}

variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "aks"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}
variable "aks_agent_os_disk_type" {
  description = "Type of OS Disk Ephemeral(Default) or Managed"
  default     = "Ephemeral"
}

variable "aks_agent_count" {
  description = "The number of agent nodes for the cluster."
  default     = 12
}

variable "aks_agent_vm_size" {
  description = "VM size"
  default     = "standard_d2s_v3"
}

variable "aks_agent_os_sku" {
  type        = string
  description = "(Optional) SKU to be used to specify Linux OS. Not applicable to Windows. Possible values include: Ubuntu, CBLMariner. Defaults to Ubuntu. Changing this forces a new resource to be created."
  default     = "Ubuntu"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.24.3"
}

variable "aks_service_cidr" {
  description = "CIDR notation IP range from which to assign service cluster IPs"
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}
