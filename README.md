# Network Policy Demo with roxctl

Enhanced demonstration of automated Kubernetes network policy generation and analysis using Red Hat Advanced Cluster Security (RHACS) `roxctl` tool.

## Overview

This demo showcases:
- **Automated network policy generation** from live Kubernetes deployments
- **Zero-trust enforcement** - demonstrating blocked connectivity after policies are applied
- **Network connectivity visualization** using DOT graphs
- **Exposure analysis** focused on specific workloads
- **Explainability** - detailed connectivity reports for troubleshooting

## Architecture

Based on [mostmark's fork of the Online Boutique microservices demo](https://github.com/mostmark/microservices-demo), deployed on OpenShift.

## Prerequisites

### Tools Required
- **roxctl** - Red Hat Advanced Cluster Security CLI
  ```bash
  # Option 1: Download from your RHACS Central instance
  # Navigate to: Platform Configuration > Integrations > StackRox API Token
  # Download roxctl for your platform
  
  # Option 2: Build from source
  # https://github.com/stackrox/stackrox
  ```
- **xdot** - GraphViz DOT file viewer
  ```bash
  brew install xdot
  ```
- **oc** - OpenShift CLI
  ```bash
  brew install openshift-cli
  ```

### OpenShift Cluster Access
- Active OpenShift cluster with `ms-demo` namespace
- Online Boutique application deployed
- Cluster admin or appropriate RBAC permissions

## Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/netpol-demo.git
cd netpol-demo

# Initialize submodule (contains the microservices demo manifests)
git submodule init
git submodule update
```

### 2. Configure OpenShift Access
```bash
# Set your kubeconfig
export KUBECONFIG=~/.kube/config-your-cluster

# Login to OpenShift
oc login https://your-cluster-url

# Verify access
oc whoami
oc get projects
```

### 3. Deploy Application (if not already deployed)
```bash
cd microservices-demo

# Create namespace
oc apply -f kubernetes-manifests/namespace_ms-demo.yaml

# Deploy all services
oc apply -f kubernetes-manifests/

# Wait for all pods to be ready
oc get pods -n ms-demo -w
```

### 4. Verify Application
```bash
# Get the frontend route
oc get route -n ms-demo frontend

# Open in browser
open "http://$(oc get route -n ms-demo frontend -o jsonpath='{.spec.host}')"
```

## Running the Demo

```bash
cd microservices-demo
../demo.sh
```

The demo is interactive and walks through 4 use cases:

### Use Case 1: Generate Network Policies and Visualize Connectivity
- Generates tight network policies using `roxctl`
- Tests connectivity **before** applying policies (adservice → paymentservice succeeds)
- Applies generated network policies
- Tests connectivity **after** applying policies (adservice → paymentservice blocked)
- Visualizes the complete connectivity map

### Use Case 2: Analyze Exposure
- Applies AdminNetworkPolicy (ANP) for Prometheus monitoring
- Analyzes frontend workload exposure
- Shows ingress/egress connections with focus on external access

### Use Case 3: Explainability
- Generates detailed connectivity explanation for frontend
- Reviews allowed/denied connections
- Shows practical troubleshooting workflow

## Demo Helper Functions

The demo script includes reusable helper functions:

### `demo_launch [-o output_file] command [args...]`
Displays commands with inverse video highlighting before execution.
```bash
# Show command output on terminal
demo_launch roxctl netpol generate ...

# Save output to file
demo_launch -o output.txt roxctl netpol connectivity map ...

# Suppress output
demo_launch -o /dev/null oc apply -f policies.yaml
```

### `demo_show "message"`
Displays highlighted informational messages.
```bash
demo_show "▶ Generating network policies with roxctl..."
```

### `demo_prompt "prompt text"`
Interactive pause with custom prompt message.
```bash
demo_prompt "Press any key to continue..."
```

## Generated Artifacts

### DOT/ Directory
Connectivity visualization files (GraphViz DOT format):
- `connectivity-map.dot` - Full cluster connectivity
- `frontend-connectivity-map.dot` - Frontend-focused exposure map
- `explain.txt` - Detailed connectivity explanation

### NETPOL/ Directory
Generated network policies:
- `network-policies.yaml` - Generated NetworkPolicy resources
- `ANP-add-monitoring-with-ports-to-all-NS.yaml` - AdminNetworkPolicy for monitoring

## Key Features

### Zero-Trust Demonstration
Shows how network policies enforce least-privilege communication:
- **Before policies**: Services can connect to anything
- **After policies**: Only explicitly allowed connections work
- **Application still works**: Legitimate traffic flows normally

### Visual Connectivity Maps
- Color-coded connection flows
- Distinguishes internal vs external access
- Highlights DNS, monitoring, and application traffic

### Network Policy Best Practices
- Default deny for both ingress and egress
- Explicit allow for legitimate service-to-service communication
- DNS egress rules (UDP 5353 for CoreDNS)
- AdminNetworkPolicy for cluster-wide monitoring exceptions

## Troubleshooting

### roxctl not found
```bash
# Download from RHACS Central
# Navigate to: Platform Configuration > Integrations > StackRox API Token
# Download roxctl for your platform
```

### Network policies not blocking traffic
```bash
# Verify policies are applied
oc get networkpolicies -n ms-demo

# Check for conflicting AdminNetworkPolicy
oc get adminnetworkpolicies

# Review policy details
oc describe networkpolicy <policy-name> -n ms-demo
```

### xdot not displaying graphs
```bash
# macOS: Ensure X11/XQuartz is installed
brew install --cask xquartz

# Restart terminal after installation
```

## Project Structure

```
.
├── demo.sh                          # Main demo script
├── microservices-demo/              # Submodule: Google Online Boutique
│   ├── kubernetes-manifests/        # K8s deployment manifests
│   └── README.md
├── DOT/                             # Generated connectivity visualizations
│   ├── 01-connectivity-map.dot
│   ├── 02-frontend-connectivity-map.dot
│   ├── 03-frontend-exposure-map.dot
│   ├── 04-explain.md
│   └── 05-frontend-connectivity-summary.md
├── NETPOL/                          # Generated network policies
│   ├── 00-network-policies.txt      # Template
│   └── 01-ANP-add-monitoring-with-ports-to-all-NS.txt
└── README.md                        # This file
```

## Contributing

This is a personal demo environment. For the microservices demo, see:
- mostmark's fork: https://github.com/mostmark/microservices-demo
- Original Google demo: https://github.com/GoogleCloudPlatform/microservices-demo

## License

Demo scripts: MIT License  
Microservices Demo: Apache 2.0 (see microservices-demo/README.md)

## References

- [Red Hat Advanced Cluster Security](https://www.redhat.com/en/technologies/cloud-computing/openshift/advanced-cluster-security-kubernetes)
- [roxctl CLI Documentation](https://docs.openshift.com/acs/cli/getting-started-cli.html)
- [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [OpenShift AdminNetworkPolicy](https://docs.openshift.com/container-platform/latest/networking/network_policy/about-network-policy.html)

