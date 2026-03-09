# Demonstration of Automatic Kubernetes Network Policies
## KubecCon NA 2025


This demo is an interactive supplement to the slides. 

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
  - **Option 1:** Download from your RHACS Central instance
  - **Option 2:** Build from source: https://github.com/stackrox/stackrox

- A GraphViz DOT file viewer. There are great VScode plugins. You may also try xdot 
  ```bash
  brew install xdot
  ```

### OpenShift Cluster Access
- Active OpenShift cluster with `ms-demo` namespace
- Online Boutique application deployed
- Cluster admin or appropriate RBAC permissions

## Setup Instructions

### 1. Prepare the Shop
```bash
git clone https://github.com/boazmichaely/kubecon-na-2025-netpol-demo.git
cd kubecon-na-2025-netpol-demo

# Clone mostmark's microservices demo
git clone https://github.com/mostmark/microservices-demo.git

# create the demo in the OCP cluster
1. login as admin (use OCP UI copy login command) 
2. run these comands
% oc whoami --show-context
% oc new-project ms-demo
% cd microservices-demo
% oc apply -f application.yaml
```

### 2. open Chrome windows that would be used during the demo
1. The slide deck (update the slide deck title in demo.sh setting)
2. OCP NetworkPolicies  (e.g. https://console-openshift-console.apps.do-not-delete-boaz-demo.ocp.infra.rox.systems/k8s/ns/ms-demo/networking.k8s.io~v1~NetworkPolicy)
3. OCP AdminNetworkPolicies (this is in CRD section under Administration e.g. https://console-openshift-console.apps.do-not-delete-boaz-demo.ocp.infra.rox.systems/k8s/cluster/customresourcedefinitions/adminnetworkpolicies.policy.networking.k8s.io)

## Running the Demo

```bash
cd microservices-demo
../demo.sh run
```
(With no arguments, `../demo.sh` shows help.)

## Contributing

This is a personal demo environment. For the microservices demo, see:
- mostmark's fork: https://github.com/mostmark/microservices-demo

## License

Demo scripts: MIT License  
Microservices Demo: Apache 2.0 (see microservices-demo/README.md)
