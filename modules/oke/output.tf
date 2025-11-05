# ============================================
# OKE MODULE OUTPUTS - CLUSTER ONLY
# ============================================

output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = oci_containerengine_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the OKE cluster"
  value       = oci_containerengine_cluster.cluster.name
}

output "cluster_kubernetes_version" {
  description = "Kubernetes version of the cluster"
  value       = oci_containerengine_cluster.cluster.kubernetes_version
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = oci_containerengine_cluster.cluster.endpoints[0].kubernetes
}

output "kubeconfig" {
  description = "Kubeconfig content for cluster access"
  value       = data.oci_containerengine_cluster_kube_config.kube_config.content
  sensitive   = true
}
