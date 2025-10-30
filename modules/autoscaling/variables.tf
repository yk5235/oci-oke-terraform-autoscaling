# ============================================
# AUTOSCALING MODULE VARIABLES
# ============================================

# ============================================
# COMMON VARIABLES
# ============================================

variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

variable "cluster_id" {
  description = "OCID of the OKE cluster"
  type        = string
}

# ============================================
# NETWORK DEPENDENCIES
# ============================================

variable "worker_subnet_id" {
  description = "OCID of the worker nodes subnet"
  type        = string
}

variable "pod_subnet_id" {
  description = "OCID of the pod subnet"
  type        = string
}

# ============================================
# NODE POOL CONFIGURATION
# ============================================

variable "node_pool_name" {
  description = "Name of the autoscaling node pool"
  type        = string
  default     = "oke-autoscaling-pool"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the node pool"
  type        = string
}

variable "node_shape" {
  description = "Shape of the worker nodes"
  type        = string
  default     = "VM.Standard.E3.Flex"
}

variable "node_pool_node_shape_config_ocpus" {
  description = "Number of OCPUs for worker nodes"
  type        = number
  default     = 2
  validation {
    condition     = var.node_pool_node_shape_config_ocpus >= 1
    error_message = "OCPUs must be at least 1."
  }
}

variable "node_pool_node_shape_config_memory_in_gbs" {
  description = "Memory in GBs for worker nodes"
  type        = number
  default     = 16
  validation {
    condition     = var.node_pool_node_shape_config_memory_in_gbs >= 1
    error_message = "Memory must be at least 1 GB."
  }
}

variable "boot_volume_size_in_gbs" {
  description = "Size of the boot volume for worker nodes in GB"
  type        = number
  default     = 50
  validation {
    condition     = var.boot_volume_size_in_gbs >= 50
    error_message = "Boot volume size must be at least 50 GB."
  }
}

variable "ssh_public_key" {
  description = "SSH public key for accessing worker nodes"
  type        = string
}

variable "cni_type" {
  description = "CNI type for pod networking"
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "max_pods_per_node" {
  description = "Maximum number of pods per node"
  type        = number
  default     = null
}

variable "nsg_ids" {
  description = "List of Network Security Group OCIDs"
  type        = list(string)
  default     = []
}

variable "pod_nsg_ids" {
  description = "List of Network Security Group OCIDs for pods"
  type        = list(string)
  default     = []
}

# ============================================
# AUTOSCALING CONFIGURATION
# ============================================

variable "enable_autoscaling" {
  description = "Enable cluster autoscaling for this node pool"
  type        = bool
  default     = true
}

variable "initial_node_count" {
  description = "Initial number of nodes in the pool"
  type        = number
  default     = 2
  validation {
    condition     = var.initial_node_count > 0
    error_message = "Initial node count must be at least 1."
  }
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 2
  validation {
    condition     = var.min_node_count > 0
    error_message = "Minimum node count must be at least 1."
  }
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 5
  validation {
    condition     = var.max_node_count > 0 && var.max_node_count <= 1000
    error_message = "Maximum node count must be between 1 and 1000."
  }
}

variable "eviction_grace_duration" {
  description = "Duration (in format PT#H#M#S) to wait before evicting pods from a node during scale down"
  type        = string
  default     = "PT1H"
}

variable "is_force_delete_after_grace_duration" {
  description = "Force delete pods after grace duration during node eviction"
  type        = bool
  default     = false
}

variable "is_pv_encryption_in_transit_enabled" {
  description = "Enable encryption in transit for persistent volumes"
  type        = bool
  default     = false
}

# ============================================
# TAGGING
# ============================================

variable "freeform_tags" {
  description = "Freeform tags for the node pool"
  type        = map(string)
  default     = {}
}
