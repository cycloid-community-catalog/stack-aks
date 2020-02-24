#
# Dedicated VPC
#

module "azure-network" {
  source  = "Azure/network/azurerm"
  version = "~> 2.0.0"

  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_name           = "${var.project}-${var.env}-vnet"
  address_space       = var.address_space
  subnet_prefixes     = [
    for subnet in var.subnets:
    subnet.address_prefix
  ]
  subnet_names        = [
    for subnet in var.subnets:
    subnet.name
  ]

  tags = merge(local.merged_tags, {
    name = "${var.project}-${var.env}-vnet"
  })
}

# resource "azurerm_subnet" "subnet" {
#   for_each = var.subnets

#   name                      = "${var.project}-${var.env}-${each.value.name}"
#   address_prefix            = each.value.address_prefix
#   resource_group_name       = var.resource_group_name
#   virtual_network_name      = module.azure-network.vnet_name
#   network_security_group_id = azurerm_network_security_group.aks-nodes.id
# }
