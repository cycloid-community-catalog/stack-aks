# network
output "vnet_id" {
  description = "AKS Cluster dedicated vNet ID."
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "AKS Cluster dedicated vNet name."
  value       = module.network.vnet_name
}

output "vnet_location" {
  description = "AKS Cluster dedicated vNet location."
  value       = module.network.vnet_location
}

output "vnet_subnet_ids" {
  description = "AKS Cluster dedicated vNet subnet IDs."
  value       = module.network.vnet_subnets
}

output "vnet_address_space" {
  description = "AKS Cluster dedicated vNet address space."
  value       = module.network.vnet_address_space
}

output "nodes_sg_allow" {
  description = "AKS Cluster dedicated vNet security group to allow SSH and metrics access to instances."
  value       = module.network.nodes_sg_allow
}


# AKS Cluster
output "cluster_id" {
  description = "AKS Cluster ID."
  value       = module.aks.cluster_id
}

output "cluster_public_fqdn" {
  description = "AKS Cluster public FQDN."
  value       = module.aks.cluster_public_fqdn
}

output "cluster_private_fqdn" {
  description = "AKS Cluster private FQDN."
  value       = module.aks.cluster_private_fqdn
}

output "control_plane_host" {
  description = "AKS Cluster kubeconfig host."
  value       = module.aks.control_plane_host
}

output "control_plane_ca" {
  description = "AKS Cluster certificate authority."
  value       = module.aks.control_plane_ca
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the AKS Cluster."
  value       = module.aks.kubeconfig
}