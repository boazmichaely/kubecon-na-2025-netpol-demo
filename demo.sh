#!/usr/bin/env bash
{ set +x; } 2>/dev/null
clear

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
rm -f ../NETPOL/*.yaml
rm -f ../DOT/connectivity-map.dot
rm -f ../DOT/frontend-connectivity-map.dot
rm -f ../DOT/explain.md

cat <<EOF

####################################################################
# DEMO 1 - Generate Network Policies and visualize connectivity
####################################################################
EOF
read -n 1 -s -p "Show the Online Boutique application ..."
pop_chrome "Online Boutique"
echo

echo
read -n 1 -s -p "======  Step 1: Generate network policies ! ======"
echo

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
read -n 1 -s -p "Apply network policies to cluster ..."
echo
set -x
oc apply -f  ../NETPOL/network-policies.yaml
{ set +x; } 2>/dev/null
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
set -x
roxctl netpol connectivity map .. -o dot -f ../DOT/connectivity-map.dot >/dev/null 
{ set +x; } 2>/dev/null
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/connectivity-map.dot
echo
read -n 1 -s -p "Show connectivity map ... "
xdot -g 1400x900 ../DOT/connectivity-map.dot >/dev/null 2>&1  &
echo

read -n 1 -s -p "on to Demo 2 ... "
echo
clear

cat <<EOF
########################################################
# DEMO 2 - How tight are the network policies? 
########################################################
EOF
echo
read -n 1 -s -p "======  Step 3: Analyze exposure with focus on frontend ======"
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

read -n 1 -s -p "on to Demo 3 ... "
echo
clear
cat <<EOF
########################################################
# DEMO 3 - Why are my apps not talking nor over exposed?
########################################################
EOF
read -n 1 -s -p "======  Step 4: Explain connectivity for frontend ======"
echo

set -x
roxctl netpol connectivity map .. --focus-workload frontend --explain > ../DOT/explain.md
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "Show connectivity explanation ... "
less ../DOT/explain.md
echo
echo
read -n 1 -s -p "Back to slides ... "
pop_chrome "Google Slides"
echo
