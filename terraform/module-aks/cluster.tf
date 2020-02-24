#
# AKS Cluster
#

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.cluster_name
  location            = var.resource_group_name
  resource_group_name = var.location
  dns_prefix          = var.cluster_name

  kubernetes_version              = var.cluster_version
  api_server_authorized_ip_ranges = var.cluster_allowed_ips

  default_node_pool {
    name           = "default"
    node_count     = 0
    vm_size        = "Standard_D1_v2"

    # Required for advanced networking
    # vnet_subnet_id = var.network_plugin == "azure" ? var.vnet_subnet_id : null
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  linux_profile {
    admin_username  = var.node_admin_username

    ssh_key {
      key_data = var.node_ssh_key
    }
  }

  dynamic "network_profile" {
    for_each = var.network_plugin == "azure" ? [1] : []

    network_plugin     = "azure"
    network_policy     = var.network_policy_plugin
    dns_service_ip     = cidrhost(var.network_service_cidr, 10)
    docker_bridge_cidr = var.network_docker_bridge_cidr
    service_cidr       = var.network_service_cidr

    # Required for availability zones
    load_balancer_sku = var.network_load_balancer_sku # standard
  }

  dynamic "network_profile" {
    for_each = var.network_plugin == "kubenet" ? [1] : []

    network_plugin = "kubenet"
    pod_cidr       = var.network_pod_cidr

    # Required for availability zones
    load_balancer_sku = var.network_load_balancer_sku # standard
  }

  enable_pod_security_policy = var.enable_pod_security_policy

  role_based_access_control {
    enabled               = var.enable_rbac

    dynamic "azure_active_directory" {
      for_each = var.rbac_use_active_directory ? [1] : []

      client_app_id       = var.rbac_client_app_id
      server_app_id       = var.rbac_server_app_id
      server_app_secret   = var.rbac_client_app_secret
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.enable_oms_agent
      log_analytics_workspace_id = var.enable_oms_agent ? azurerm_log_analytics_workspace.aks-cluster[0].id : null
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }
  }
  

  tags = merge(local.merged_tags, {
    name = var.cluster_name
  })

  lifecycle {
    ignore_changes = [
      # Ignore change for node count
      default_node_pool[0].node_count
    ]
  }
}
