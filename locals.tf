locals {
  virtual_network_address_space = [var.virtual_network_address_space]
  subnet_address_prefixes       = [cidrsubnet(var.virtual_network_address_space, 3, 0)]
}

locals {
  subnet_delegations = [
    {
      name = "containerInstanceDelegation"
      service_delegation = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
    }
  ]
}

locals {
  aci_ip_address_type = "Private"
  aci_os_type         = "Linux"

  container_instance = {
    ip_address_type = "Private"
    os_type         = "Linux"
    subnet_ids      = [module.subnet.id]

    containers = [
      {
        name   = "terraform-agent"
        image  = "hashicorp/tfc-agent:latest"
        cpu    = "1"
        memory = "2"

        ports = [{
          port     = 443
          protocol = "TCP"
        }]

        environment_variables = {
          TFC_AGENT_NAME        = "private-azure-001"
          TFC_AGENT_AUTO_UPDATE = "patch"
        }
        secure_environment_variables = {
          TFC_AGENT_TOKEN = var.tfc_agent_token
        }
      }
    ]
  }
}
