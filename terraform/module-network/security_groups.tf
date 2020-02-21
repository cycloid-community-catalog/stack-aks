resource "azurerm_network_security_group" "aks-nodes" {
  name                = "${var.cluster_name}-nodes"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "${var.cluster_name}-inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.ssh_allowed_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "${var.cluster_name}-inbound-metrics"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefixes    = var.metrics_allowed_ips
    destination_address_prefix = "*"
  }

  tags = merge(local.merged_tags, {
    name = "${var.cluster_name}-nodes"
  })

  depends_on = [
    "module.azure-network"
  ]
}