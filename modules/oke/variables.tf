# ============================================
# OKE MODULE VARIABLES - CLUSTER ONLY
# ============================================

variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN"
  type        = string
}

variable "kubapi_subnet_id" {
  description = "OCID of the Kubernetes API endpoint subnet"
  type        = string
}

variable "lb_subnet_id" {
  description = "OCID of the Load Balancer subnet"
  type        = string
}

variable "worker_subnet_id" {
  description = "OCID of the worker nodes subnet"
  type        = string
}

variable "pod_subnet_id" {
  description = "OCID of the pod subnet"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OKE cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
}

variable "cluster_type" {
  description = "Type of OKE cluster (BASIC_CLUSTER or ENHANCED_CLUSTER)"
  type        = string
  default     = "ENHANCED_CLUSTER"
}

variable "cni_type" {
  description = "CNI type for pod networking (OCI_VCN_IP_NATIVE or FLANNEL_OVERLAY)"
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "is_public_ip_enabled" {
  description = "Whether the Kubernetes API endpoint has a public IP"
  type        = bool
}

variable "is_kubernetes_dashboard_enabled" {
  description = "Whether to enable the Kubernetes Dashboard"
  type        = bool
  default     = false
}
