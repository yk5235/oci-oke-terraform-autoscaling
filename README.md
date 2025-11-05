# 🚀 OCI OKE Terraform - Autoscaling Workshop

Terraform configuration for deploying Oracle Kubernetes Engine (OKE) clusters with **cluster autoscaling** on Oracle Cloud Infrastructure. This module is specifically designed for demonstrating and learning OKE autoscaling capabilities.

## ✨ Key Features

- ✅ **Autoscaling-First Design** - Single autoscaling node pool (no regular node pool)
- ✅ **Configurable Autoscaling** - Set min/max nodes and watch the magic happen
- ✅ **VCN-Native Pod Networking** - High performance with OCI_VCN_IP_NATIVE
- ✅ **Bastion Host Support** - Secure access for private API endpoints
- ✅ **Production-Ready** - Based on OCI best practices
- ✅ **Workshop-Optimized** - Clear structure for learning autoscaling

## 🎯 What's Different from Regular OKE?

This module focuses **exclusively on autoscaling**:

| Feature | Regular OKE Module | Autoscaling Workshop Module |
|---------|-------------------|----------------------------|
| Node Pools | Regular + Autoscaling | **Autoscaling Only** |
| Use Case | General OKE deployments | **Learning autoscaling** |
| Node Count | Fixed size | **Dynamic (min to max)** |
| Cluster Autoscaler | Optional | **Required** |

## 🎯 Quick Start

### 1. Prerequisites

- OCI Account with appropriate permissions
- Terraform >= 1.0
- SSH key pair generated

### 2. Configure Your Deployment

```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vi terraform.tfvars
```

**Minimum required configuration:**
```hcl
region         = "ap-singapore-1"
compartment_id = "ocid1.compartment.oc1..your-ocid"
ssh_public_key = "ssh-rsa AAAAB3..."

# Autoscaling configuration
enable_autoscaling = true
initial_node_count = 1
min_node_count     = 1
max_node_count     = 5
```

### 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

**Deployment time:** ~12-15 minutes

### 4. Deploy Cluster Autoscaler

After the infrastructure is ready, deploy the cluster autoscaler:

```bash
# Get kubeconfig
terraform output -raw kubeconfig > ~/.kube/config

# If using private API, setup SSH tunnel first
# (see "Accessing the Cluster" section)

# Deploy cluster autoscaler (see workshop instructions)
kubectl apply -f cluster-autoscaler.yaml
```

### 5. Test Autoscaling

```bash
# Watch nodes in real-time
kubectl get nodes -w

# Deploy a test workload that triggers scaling
kubectl apply -f test-autoscaling-deployment.yaml

# Observe nodes being added automatically
# When you delete the deployment, nodes will scale down
```

## 📊 Autoscaling Configuration Options

### Development Environment
```hcl
enable_autoscaling = true
initial_node_count = 1
min_node_count     = 0   # Can scale to zero
max_node_count     = 3
```

### Production Environment
```hcl
enable_autoscaling = true
initial_node_count = 2
min_node_count     = 2   # Always maintain capacity
max_node_count     = 10
```

### Testing/Fixed Size
```hcl
enable_autoscaling = false  # Disable autoscaling
initial_node_count = 1
min_node_count     = 1
max_node_count     = 1
```

## 📁 Project Structure

```
oci-oke-terraform-autoscaling/
├── main.tf                      # Root orchestration (networking + OKE + autoscaling + bastion)
├── variables.tf                 # Root variables (autoscaling-focused)
├── outputs.tf                   # Root outputs (includes autoscaling info)
├── terraform.tfvars.example     # Example configuration
├── README.md                    # This file
│
├── modules/
│   ├── networking/              # VCN, subnets, gateways, routing
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── oke/                     # Cluster ONLY (no node pool)
│   │   ├── main.tf              # Creates cluster, no node pool
│   │   ├── variables.tf         # Cluster configuration only
│   │   ├── outputs.tf           # Cluster outputs
│   │   └── data.tf              # Data sources for cluster
│   │
│   ├── autoscaling/             # Autoscaling node pool
│   │   ├── main.tf              # Node pool with autoscaling
│   │   ├── variables.tf         # Autoscaling configuration
│   │   ├── outputs.tf           # Node pool outputs
│   │   └── data.tf              # Data sources for nodes
│   │
│   └── bastion/                 # Bastion host (optional but recommended)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

## 🎓 Understanding Autoscaling

### How It Works

1. **Initial State**: Cluster starts with `initial_node_count` nodes
2. **Scale Up Trigger**: When pods are pending due to insufficient resources
3. **Scale Up Action**: Autoscaler adds nodes (up to `max_node_count`)
4. **Scale Down Trigger**: When nodes are underutilized for ~10 minutes
5. **Scale Down Action**: Autoscaler removes nodes (down to `min_node_count`)

### Key Components

```
┌─────────────────────────────────────────────────────┐
│              OKE Cluster                            │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │         Cluster Autoscaler                   │  │
│  │  (Monitors pod scheduling & node usage)      │  │
│  └──────────────────────────────────────────────┘  │
│                       │                             │
│                       ▼                             │
│  ┌──────────────────────────────────────────────┐  │
│  │       Autoscaling Node Pool                  │  │
│  │                                              │  │
│  │  [Node 1] [Node 2] ... [Node N]             │  │
│  │   min: 1              max: 5                 │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Important Variables

| Variable | Description | Impact |
|----------|-------------|---------|
| `enable_autoscaling` | Enable/disable autoscaling | Must be `true` |
| `initial_node_count` | Starting number of nodes | Initial capacity |
| `min_node_count` | Minimum nodes maintained | Never scales below |
| `max_node_count` | Maximum nodes allowed | Never scales above |
| `eviction_grace_duration` | Time to wait before forcing pod eviction | Affects scale-down speed |

## 🔧 Advanced Configuration

### Node Shape Customization

```hcl
node_shape                                = "VM.Standard.E4.Flex"
node_pool_node_shape_config_ocpus         = 4
node_pool_node_shape_config_memory_in_gbs = 32
boot_volume_size_in_gbs                   = 100
```

### Network Customization

```hcl
vcn_cidr                = "172.16.0.0/16"
kubapi_subnet_is_public = false  # Private (recommended)
lb_subnet_is_public     = true   # Public load balancers
```

### Eviction Settings

```hcl
eviction_grace_duration              = "PT60M"  # 60 minutes
is_force_delete_after_grace_duration = false    # Don't force delete
```

## 📊 Outputs

After deployment, you'll get comprehensive information:

```bash
# View all outputs
terraform output

# Get kubeconfig
terraform output -raw kubeconfig > ~/.kube/config

# View autoscaling configuration
terraform output autoscaling_configuration

# View deployment summary
terraform output deployment_summary

# Get quick start commands
terraform output quick_start_commands
```

## 🎯 Accessing the Cluster

### Private KubeAPI (Recommended - Default)

```bash
# 1. Get bastion IP
terraform output bastion_public_ip

# 2. Setup SSH tunnel
ssh -i <private_key> -N -L 6443:<cluster-private-ip>:6443 opc@<bastion-ip>

# 3. Update kubeconfig
# Change server from: https://10.0.0.x:6443
# To: https://127.0.0.1:6443

# 4. Use kubectl
kubectl get nodes
```

### Public KubeAPI (Development Only)

```bash
# Set in terraform.tfvars
kubapi_subnet_is_public = true

# Get kubeconfig and use directly
terraform output -raw kubeconfig > ~/.kube/config
kubectl get nodes
```

## 🧪 Testing Autoscaling

### 1. Deploy Test Workload

Create a deployment that will trigger autoscaling:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: autoscale-test
spec:
  replicas: 10  # More than current capacity
  selector:
    matchLabels:
      app: autoscale-test
  template:
    metadata:
      labels:
        app: autoscale-test
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
```

### 2. Monitor Scaling

```bash
# Watch nodes being added
kubectl get nodes -w

# Check pending pods
kubectl get pods

# View autoscaler logs
kubectl logs -n kube-system deployment/cluster-autoscaler
```

### 3. Test Scale Down

```bash
# Delete the deployment
kubectl delete deployment autoscale-test

# Watch nodes being removed (after ~10 minutes)
kubectl get nodes -w
```

## 🧹 Cleanup

```bash
# Delete all Kubernetes resources first
kubectl delete all --all --all-namespaces

# Then destroy infrastructure
terraform destroy
```

**Destruction time:** ~5-10 minutes

## 🔍 Troubleshooting

### Autoscaler Not Scaling Up

**Check:**
1. Are there pending pods? `kubectl get pods -A`
2. Is autoscaler running? `kubectl get deployment -n kube-system cluster-autoscaler`
3. Check logs: `kubectl logs -n kube-system deployment/cluster-autoscaler`
4. Verify IAM policies allow node creation

### Autoscaler Not Scaling Down

**Check:**
1. Has utilization been low for 10+ minutes?
2. Are there DaemonSets preventing node drain?
3. Check node annotations: `kubectl describe node <node-name>`
4. Review autoscaler logs for scale-down events

### Cannot Access Cluster

**Private API:**
- Ensure SSH tunnel is active
- Verify kubeconfig points to 127.0.0.1:6443
- Check bastion security rules

**Public API:**
- Verify security list allows your IP
- Check kubeconfig has correct endpoint

## 📝 Best Practices

### Autoscaling
- ✅ Start with conservative `min_node_count` for production
- ✅ Set `max_node_count` based on quota and budget
- ✅ Monitor autoscaling behavior and adjust thresholds
- ✅ Use pod disruption budgets for graceful scaling
- ✅ Set appropriate resource requests on pods

### Security
- ✅ Use private API endpoint (default in this module)
- ✅ Access cluster via bastion host
- ✅ Implement Network Security Groups
- ✅ Rotate SSH keys regularly
- ✅ Enable audit logging

### Cost Optimization
- ✅ Use `min_node_count = 0` for dev environments
- ✅ Set appropriate `eviction_grace_duration`
- ✅ Right-size node shapes
- ✅ Monitor actual usage vs capacity
- ✅ Use spot instances for non-critical workloads (future enhancement)

## 🚀 What Makes This Different?

### Compared to oci-oke-terraform-refactored

1. **Single Purpose**: Focused exclusively on autoscaling
2. **No Regular Node Pool**: Only autoscaling node pool exists
3. **Simplified Configuration**: Variables optimized for autoscaling
4. **Workshop Ready**: Clear examples and documentation
5. **Autoscaler Required**: Infrastructure designed for autoscaler deployment

## 📚 Workshop Flow

1. **Deploy Infrastructure** (this Terraform module)
   - Creates VCN, subnets, OKE cluster
   - Creates autoscaling node pool (initially 1 node)
   - Creates bastion host

2. **Deploy Cluster Autoscaler** (Kubernetes manifests)
   - Install autoscaler in kube-system namespace
   - Configure to watch your node pool
   - Grant necessary IAM permissions

3. **Test Autoscaling** (Workshop exercises)
   - Deploy workloads exceeding capacity
   - Watch nodes being added
   - Remove workloads
   - Watch nodes being removed

4. **Understand Metrics** (Monitoring)
   - View autoscaler decisions
   - Monitor node utilization
   - Analyze scaling patterns

## 🤝 Contributing

Found an issue or have a suggestion? Please open an issue or pull request!

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues related to:
- **This Terraform module**: Open a GitHub issue
- **OKE platform**: Consult OCI documentation
- **Kubernetes**: Check Kubernetes documentation
- **Cluster Autoscaler**: See cluster-autoscaler documentation

---

**Happy Autoscaling! 🎉**
