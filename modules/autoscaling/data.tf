# ============================================
# AUTOSCALING MODULE DATA SOURCES
# ============================================

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Use the same simple pattern as the main OKE module
# This gets all Oracle Linux 8 images for the specified shape
# OCI automatically returns OKE-compatible images when querying for a shape used in OKE
data "oci_core_images" "node_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.node_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
