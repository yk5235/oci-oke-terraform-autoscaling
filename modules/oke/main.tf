# ============================================
# OKE MODULE MAIN - CLUSTER ONLY
# For autoscaling workshop - no regular node pool
# ============================================

resource "oci_containerengine_cluster" "cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  type               = var.cluster_type

  cluster_pod_network_options {
    cni_type = var.cni_type
  }

  endpoint_config {
    is_public_ip_enabled = var.is_public_ip_enabled
    subnet_id            = var.kubapi_subnet_id
  }

  options {
    service_lb_subnet_ids = [var.lb_subnet_id]

    add_ons {
      is_kubernetes_dashboard_enabled = var.is_kubernetes_dashboard_enabled
    }
  }
}
