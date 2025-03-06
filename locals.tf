locals {
  resources = {
    resource_group = {
      resource_type = "rg"
      purpose       = ""
    }
    virtual_network = {
      resource_type = "vnet"
      purpose       = ""
    }
    private_dns_zone = {
      resource_type = "privatedns"
      purpose       = "ac"
    }
  }
}
