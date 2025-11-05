# ============================================
# OKE MODULE DATA SOURCES
# ============================================

data "oci_containerengine_cluster_kube_config" "kube_config" {
  cluster_id = oci_containerengine_cluster.cluster.id
}
