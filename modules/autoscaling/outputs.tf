# ============================================
# AUTOSCALING MODULE OUTPUTS
# ============================================

output "autoscaling_node_pool_id" {
  description = "OCID of the autoscaling node pool"
  value       = oci_containerengine_node_pool.autoscaling_node_pool.id
}

output "autoscaling_node_pool_name" {
  description = "Name of the autoscaling node pool"
  value       = oci_containerengine_node_pool.autoscaling_node_pool.name
}

output "autoscaling_node_pool_kubernetes_version" {
  description = "Kubernetes version of the autoscaling node pool"
  value       = oci_containerengine_node_pool.autoscaling_node_pool.kubernetes_version
}

output "autoscaling_configuration" {
  description = "Autoscaling configuration details"
  value = {
    enabled           = var.enable_autoscaling
    initial_nodes     = var.initial_node_count
    min_nodes         = var.min_node_count
    max_nodes         = var.max_node_count
    node_shape        = var.node_shape
    ocpus_per_node    = var.node_pool_node_shape_config_ocpus
    memory_per_node   = var.node_pool_node_shape_config_memory_in_gbs
    eviction_grace    = var.eviction_grace_duration
  }
}

output "node_pool_nodes" {
  description = "Information about nodes in the autoscaling pool"
  value = {
    pool_id = oci_containerengine_node_pool.autoscaling_node_pool.id
    shape   = var.node_shape
    subnet  = var.worker_subnet_id
  }
}

output "node_image_id" {
  description = "OCID of the node image being used"
  value       = data.oci_core_images.node_images.images[0].id
}
