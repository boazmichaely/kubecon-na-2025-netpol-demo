# Kubernetes Network Policy Toolkit Demo using roxctl (based on NP-Guard)


This demo is an interactive supplement to my slides and assumes the slides are open in chrome
https://kccncna2025.sched.com/event/e90814e6c4b2e7a73f590da3f17d68b1 


## Overview

This demo showcases the `roxctl netpol` features:
* Network Policy Generation
  - Default-deny on namespace
  - Tight connections for listed workloads
  - Implied need for DNS, only when needed!  (+ control DNS port)
* Connectivity Analysis (static)
  - Connectivity map: concrete connections for listed workloads
  - Exposure option: allowed connections beyond listed workloads
  - Visualization formats: txt, json, md, dot, csv
  - Focus option: limit the analysis to a particular workload
* Advanced analysis
  - Explain the rule stack leading to connection allowed or denied (txt only)
  - Diff: 	Visualize differences in connectivity between two project versions
    - Considers both workloads and network policies
    - Formats: txt, md, csv, dot

## Architecture

Based on [mostmark's fork of the Online Boutique microservices demo](https://github.com/mostmark/microservices-demo), deployed on OpenShift.

## Prerequisites

### Tools Required
- **roxctl** - Red Hat Advanced Cluster Security CLI
  # Option 1: Download from your RHACS Central instance
  
  # Option 2: Build from source
  # https://github.com/stackrox/stackrox

- A GraphViz DOT file viewer. There are great VScode plugins. You may also try xdot 
  ```bash
  brew install xdot
  ```

### OpenShift Cluster Access
- Active OpenShift cluster with `ms-demo` namespace
- Online Boutique application deployed
- Cluster admin or appropriate RBAC permissions

## Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/boazmichaely/kubecon-na-2025-netpol-demo.git
cd kubecon-na-2025-netpol-demo

# Clone mostmark's microservices demo
git clone https://github.com/mostmark/microservices-demo.git
```

## Running the Demo

```bash
cd microservices-demo
../demo.sh
```

## Contributing

This is a personal demo environment. For the microservices demo, see:
- mostmark's fork: https://github.com/mostmark/microservices-demo
- Original Google demo: https://github.com/GoogleCloudPlatform/microservices-demo

## License

Demo scripts: MIT License  
Microservices Demo: Apache 2.0 (see microservices-demo/README.md)
