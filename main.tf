module "resource_group" {
  source  = "app.terraform.io/leshawn-rice/resource-group/azurerm"
  version = "1.2.0"

  application = var.application
  environment = var.environment
  location    = var.location
}

module "virtual_network" {
  source  = "app.terraform.io/leshawn-rice/virtual-network/azurerm"
  version = "1.0.2"

  application         = var.application
  environment         = var.environment
  location            = var.location
  dns_servers         = null
  address_space       = local.virtual_network_address_space
  resource_group_name = module.resource_group.name
}

module "subnet" {
  source  = "app.terraform.io/leshawn-rice/subnet/azurerm"
  version = "1.0.5"

  application          = var.application
  environment          = var.environment
  location             = var.location
  workload             = "agents"
  address_prefixes     = local.subnet_address_prefixes
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name

  delegations = local.subnet_delegations
}

module "container_instance" {
  source  = "app.terraform.io/leshawn-rice/container-group/azurerm"
  version = "1.0.1"

  application     = var.application
  environment     = var.environment
  workload        = "tfagent"
  instance_number = "1"

  location            = var.location
  resource_group_name = module.resource_group.name
  ip_address_type     = local.container_instance.ip_address_type
  os_type             = local.container_instance.os_type

  subnet_ids = local.container_instance.subnet_ids
  containers = local.container_instance.containers
}
