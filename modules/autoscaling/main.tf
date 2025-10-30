# ============================================
# OKE AUTOSCALING MODULE
# Node Pool with Cluster Autoscaling Enabled
# ============================================

resource "oci_containerengine_node_pool" "autoscaling_node_pool" {
  cluster_id         = var.cluster_id
  compartment_id     = var.compartment_id
  name               = var.node_pool_name
  kubernetes_version = var.kubernetes_version
  node_shape         = var.node_shape

  node_source_details {
    image_id                = data.oci_core_images.node_images.images[0].id
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.worker_subnet_id
    }

    size = var.initial_node_count

    nsg_ids = var.nsg_ids

    node_pool_pod_network_option_details {
      cni_type          = var.cni_type
      max_pods_per_node = var.max_pods_per_node
      pod_nsg_ids       = var.pod_nsg_ids
      pod_subnet_ids    = [var.pod_subnet_id]
    }
  }

  node_shape_config {
    memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
    ocpus         = var.node_pool_node_shape_config_ocpus
  }

  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.eviction_grace_duration
    is_force_delete_after_grace_duration = var.is_force_delete_after_grace_duration
  }

  ssh_public_key = var.ssh_public_key

  freeform_tags = merge(
    var.freeform_tags,
    {
      "autoscaling_enabled" = "true"
      "min_nodes"           = tostring(var.min_node_count)
      "max_nodes"           = tostring(var.max_node_count)
    }
  )

  lifecycle {
    ignore_changes = [
      node_config_details[0].size
    ]
  }
}
