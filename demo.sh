#!/usr/bin/env bash
{ set +x; } 2>/dev/null
clear

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper function to bring Chrome to front
# Usage: pop_chrome ["window title substring"]
pop_chrome() {
    if [ -z "$1" ]; then
        # No window name - just activate Chrome
        osascript -e 'tell application "Google Chrome" to activate'
    else
        # Activate specific window by title
        osascript <<EOF
tell application "Google Chrome"
    activate
    set windowList to every window
    repeat with aWindow in windowList
        if (title of aWindow) contains "$1" then
            set index of aWindow to 1
            set visible of aWindow to true
            exit repeat
        end if
    end repeat
end tell
EOF
    fi
}

#
# This is the demo script for generating and analyzing netowrk policies using roxctl
# 
# Prerequisites:
# cwd is the "microservices-demo" folder from mostmark microservices demo
# output of the parent `ls -l ..` will show:
# - microservices-demo/   - original microservices demo folder
# - NETPOL/               - folder for generated network policies
# - DOT/                  - folder for generated DOT files
# 
# output of ls -l will show the exact structure coming from git
# - application.yaml      - original application.yaml file from the microservices demo.
# - images/               - images folder from the microservices demo.
# - kubernetes-manifests/ - kubernetes manifests folder from the microservices demo.
# - README.md             - README.md file from the microservices demo.
#
# There are 3 demos to run and and additional one to simulate:
# - demo1: network policy generation and connectivity map
# - demo2: exposure analysis with focused workload
# - demo3: explainability (combined with AI)
# - Bonus (not demonstrated in this demo): diff between network policies in two different folders
# === DEMO FLOWS === 
# - demo1:
## DO show the folder (ls -l)
# SAY The application is already deployed and is working 
## DO show the web page https://frontend-ms-demo.apps.boaz-for-ac49.ocp.infra.rox.systems/
## DO SHOP for a few seconds
# SAY let's generate tight network policies for the application
## DO 
########################################################
# Clean up from previous runs
########################################################
if [ -f ../NETPOL/network-policies.yaml ]; then
    oc delete -f ../NETPOL/network-policies.yaml  2>/dev/null
fi
if [ -f ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml ]; then
    oc delete -f ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml  2>/dev/null
fi

rm -f ../NETPOL/*.yaml
rm -f ../DOT/connectivity-map.dot
rm -f ../DOT/frontend-connectivity-map.dot
rm -f ../DOT/explain.md

cat <<EOF

####################################################################
# Use Case 1 - Generate Network Policies and visualize connectivity
####################################################################
EOF
read -n 1 -s -p "Show the Online Boutique application ..."
pop_chrome "Online Boutique"
echo

echo
read -n 1 -s -p "======  Step 1: Generate network policies ! ======"
echo
echo
echo -e "${CYAN}${BOLD}▶ Generating network policies with roxctl...${NC}"
set -x
roxctl netpol generate --dnsport 5353 . --remove -f ../NETPOL/network-policies.yaml
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "view the generated network policies ..."
less ../NETPOL/network-policies.yaml
## DO show the network policies (less ../NETPOL/network-policies.yaml)
#  SAY call out 
# 1. default deny
# 2. match egress with ingress
# 3. opened  dns ports 
echo
read -n 1 -s -p "show generated  policies in slide ..."
echo
pop_chrome "Demonstration of Automatic Kubernetes Network Policies"
read -n 1 -s -p "Test connectivity before applying network policies ..."
echo
PAYMENT_IP=$(oc get svc -n ms-demo paymentservice -o jsonpath='{.spec.clusterIP}')
echo "Paymentservice IP: $PAYMENT_IP"
echo
set -x
oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
{ set +x; } 2>/dev/null
echo
echo -e "${GREEN}✓ Connection is ALLOWED (no network policies enforced yet)${NC}"
echo
read -n 1 -s -p "Apply network policies to cluster ..."
echo
set -x
oc apply -f  ../NETPOL/network-policies.yaml
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "Test connectivity after applying network policies ..."
echo
echo "Testing with same IP: $PAYMENT_IP"
echo
set -x
oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
{ set +x; } 2>/dev/null || true
echo
echo -e "${RED}✗ Connection is BLOCKED (network policies enforcing least privilege!)${NC}"
echo
read -n 1 -s -p "Show network policies in OCP console ..."
echo
pop_chrome "NetworkPolicies"
read -n 1 -s -p 'Show the app still works :-) '
pop_chrome "Online Boutique"
echo
echo
read -n 1 -s -p "======  Step 2: Generate explicit connectivity map ! ======"
echo
echo
echo -e "${CYAN}${BOLD}▶ Generating connectivity map with roxctl...${NC}"
set -x
roxctl netpol connectivity map .. -o dot -f ../DOT/connectivity-map.dot >/dev/null 
{ set +x; } 2>/dev/null
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/connectivity-map.dot
echo
read -n 1 -s -p "Show connectivity map ... "
xdot -g 1400x900 ../DOT/connectivity-map.dot >/dev/null 2>&1  &
echo

read -n 1 -s -p "on to Use Case 2 ... "
echo
pop_chrome "Demonstration of Automatic Kubernetes Network Policies"

clear

cat <<EOF
########################################################
# Use Case 2 - How tight are the network policies? 
########################################################
EOF
echo
read -n 1 -s -p  "First, let's allow monitoring using ANP"
echo
cp ../NETPOL/01-ANP-add-monitoring-with-ports-to-all-NS.txt ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml  
less ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml
read -n 1 -s -p  "oc apply ..."
echo
oc apply -f ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml
read -n 1 -s -p  "See ANP in OpenShift Console"
echo
pop_chrome "adminnetworkpolicies"
read -n 1 -s -p "======  Step 3: Analyze exposure with focus on frontend ======"
echo
echo
echo -e "${CYAN}${BOLD}▶ Analyzing exposure with roxctl...${NC}"
set -x
roxctl netpol connectivity map .. --focus-workload frontend --exposure  -o dot -f ../DOT/frontend-connectivity-map.dot --remove >/dev/null 
{ set +x; } 2>/dev/null
# we need to make some tweaks to the dot file to make it more readable, this is particular for this demo.
# STEP 1: Specific adjustments (BEFORE color replacements)
sed -i '' 's/label="TCP 8080,8443,9090" color="darkorange2" fontcolor="darkgreen" weight=1/label="TCP 8080,8443,9090" color="darkorange2" fontcolor="darkgreen" weight=2.0/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/label="UDP 5353" color="darkorange4" fontcolor="darkgreen" weight=0.5/label="UDP 5353" color="blue" fontcolor="blue" weight=2.0/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/"entire-cluster" -> "default\/frontend\[Deployment\]" \[label="TCP 8080" color="darkorange2" fontcolor="darkgreen" weight=1/"entire-cluster" -> "default\/frontend[Deployment]" [label="TCP 8080" color="red" fontcolor="red" weight=2.0/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/"{ingress-controller}" -> "default\/frontend\[Deployment\]" \[label="TCP 8080" color="gold2" fontcolor="darkgreen" weight=1\]/"{ingress-controller}" -> "default\/frontend[Deployment]" [label="TCP 8080" color="gold2" fontcolor="darkgreen" weight=1.5]/g' ../DOT/frontend-connectivity-map.dot
# STEP 2: General color replacements (AFTER specific adjustments)
sed -i '' 's/="green"/="#00FF00"/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/="darkorange2"/="#FF0000"/g' ../DOT/frontend-connectivity-map.dot
echo
read -n 1 -s -p "Show connectivity map ... "
xdot -g 1400x900 ../DOT/frontend-connectivity-map.dot  >/dev/null 2>&1 &
echo

read -n 1 -s -p "on to Use Case 3 ... "
echo
pop_chrome "Demonstration of Automatic Kubernetes Network Policies"

clear
cat <<EOF
########################################################
# Use Case 3 - Why are my apps not talking nor over exposed?
########################################################
EOF
read -n 1 -s -p "======  Step 4: Explain connectivity for frontend ======"
echo
echo
echo -e "${CYAN}${BOLD}▶ Generating connectivity explanation with roxctl...${NC}"
set -x
roxctl netpol connectivity map .. --focus-workload frontend --explain > ../DOT/explain.md
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "Show connectivity explanation ... "
less ../DOT/explain.md
echo
read -n 1 -s -p "With a littel help from Cursor (CMD ^ V) "
echo
open ../DOT/05-frontend-connectivity-summary.md
echo
read -n 1 -s -p "Back to slides ... "
pop_chrome "Google Slides"
echo
read -n 1 -s -p "End of Demo 3 ... "
echo
clear
cat <<EOF
########################################################
# DEMO 4 - Diff between network policies in two different folders
########################################################
EOF
