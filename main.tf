module "resource_group" {
  source  = "app.terraform.io/leshawn-rice/resource-group/azurerm"
  version = "1.2.0"

  application = var.application
  environment = var.environment
  location    = var.location
}

module "virtual_network" {
  source  = "app.terraform.io/leshawn-rice/virtual-network/azurerm"
  version = "1.0.0"

  application    = var.application
  environment    = var.environment
  location       = var.location
  dns_servers    = null
  address_space  = ["10.0.0.0/24"]
  resource_group = module.resource_group
}

module "subnet" {
  source  = "app.terraform.io/leshawn-rice/subnet/azurerm"
  version = "1.0.4"

  application      = var.application
  environment      = var.environment
  location         = var.location
  workload         = "agents"
  address_prefixes = ["10.0.0.0/27"]
  resource_group   = module.resource_group
  virtual_network  = module.virtual_network

  delegations = [{
    name = "subnetDelegation"

    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }]
}

# resource "azurerm_private_dns_zone" "example" {
#   name                = ""
#   resource_group_name = module.resource_group.name
# }

# ACI is container groups
# https://learn.microsoft.com/en-us/azure/container-instances/container-instances-quickstart-terraform

resource "azurerm_container_group" "tf_agent" {
  name                = "tfagent-private"
  location            = var.location
  resource_group_name = module.resource_group.name
  ip_address_type     = "Private"
  os_type             = "Linux"

  subnet_ids = ["${module.subnet.id}"]

  container {
    name   = "terraform-agent"
    image  = "hashicorp/tfc-agent:latest"
    cpu    = "1"
    memory = "2"

    ports {
      port     = 443
      protocol = "TCP"
    }

    environment_variables = {
      TFC_AGENT_TOKEN       = var.tfc_agent_token
      TFC_AGENT_NAME        = "private-azure-001"
      TFC_AGENT_AUTO_UPDATE = "true"
    }
  }

  tags = {
    environment = "testing"
    role        = "terraform-agent"
  }
}
