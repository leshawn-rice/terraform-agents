variable "client_id" {
  type        = string
  description = "Client ID of the SPN being used by terraform"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client Secret of the SPN being used by terraform"
}

variable "subscription_id" {
  type        = string
  description = "ID of the Azure Subscription"
}

variable "tenant_id" {
  type        = string
  description = "ID of the Azure Tenant"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "application" {
  type        = string
  description = "Application"
}

variable "tfc_agent_token" {
  type        = string
  sensitive   = true
  description = "Agent token for terraform agent"
}

variable "virtual_network_address_space" {
  type        = string
  description = "Subnet for the virtual network"
}
