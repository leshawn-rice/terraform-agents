module "names" {
  source = "app.terraform.io/leshawn-rice/standard-naming/azurerm"

  for_each = local.resources

  resource_type = each.value.resource_type
  application   = var.application
  environment   = var.environment
  location      = var.location
}
