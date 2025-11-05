# ============================================
# ROOT OUTPUTS - AUTOSCALING WORKSHOP
# ============================================

# ============================================
# NETWORKING OUTPUTS
# ============================================

output "vcn_id" {
  description = "OCID of the VCN"
  value       = module.networking.vcn_id
}

output "subnet_ids" {
  description = "Map of subnet names to their OCIDs"
  value       = module.networking.subnet_ids
}

output "subnet_cidrs" {
  description = "Map of subnet names to their CIDR blocks"
  value       = module.networking.subnet_cidrs
}

# ============================================
# OKE CLUSTER OUTPUTS
# ============================================

output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = module.oke.cluster_id
}

output "cluster_name" {
  description = "Name of the OKE cluster"
  value       = module.oke.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = module.oke.cluster_endpoint
}

output "cluster_kubernetes_version" {
  description = "Kubernetes version of the cluster"
  value       = module.oke.cluster_kubernetes_version
}

output "kubeconfig" {
  description = "Kubeconfig content for cluster access (use: terraform output -raw kubeconfig > ~/.kube/config)"
  value       = module.oke.kubeconfig
  sensitive   = true
}

# ============================================
# AUTOSCALING NODE POOL OUTPUTS
# ============================================

output "autoscaling_node_pool_id" {
  description = "OCID of the autoscaling node pool"
  value       = module.autoscaling.autoscaling_node_pool_id
}

output "autoscaling_node_pool_name" {
  description = "Name of the autoscaling node pool"
  value       = module.autoscaling.autoscaling_node_pool_name
}

output "autoscaling_configuration" {
  description = "Autoscaling configuration summary"
  value       = module.autoscaling.autoscaling_configuration
}

# ============================================
# BASTION OUTPUTS (if enabled)
# ============================================

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = var.enable_bastion ? module.bastion[0].bastion_public_ip : null
}

output "bastion_ssh_command" {
  description = "SSH command to connect to bastion"
  value       = var.enable_bastion ? "ssh -i <private_key_file> opc@${module.bastion[0].bastion_public_ip}" : null
}

# ============================================
# DEPLOYMENT SUMMARY
# ============================================

output "deployment_summary" {
  description = "Summary of the autoscaling deployment configuration"
  value = {
    # Cluster info
    region                 = var.region
    cluster_name           = var.cluster_name
    kubernetes_version     = var.kubernetes_version
    cluster_type           = var.cluster_type
    
    # Network info
    vcn_cidr               = var.vcn_cidr
    kubapi_is_public       = var.kubapi_subnet_is_public
    lb_is_public           = var.lb_subnet_is_public
    
    # Autoscaling info
    autoscaling_enabled    = var.enable_autoscaling
    initial_node_count     = var.initial_node_count
    min_nodes              = var.min_node_count
    max_nodes              = var.max_node_count
    node_shape             = var.node_shape
    ocpus_per_node         = var.node_pool_node_shape_config_ocpus
    memory_per_node_gb     = var.node_pool_node_shape_config_memory_in_gbs
    
    # Bastion info
    bastion_enabled        = var.enable_bastion
  }
}
