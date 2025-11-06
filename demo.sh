#!/usr/bin/env bash
{ set +x; } 2>/dev/null
clear

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[43m\033[30m'   # Yellow background, black text (marker effect)
NC='\033[0m' # No Color

# Highlight definitions for different types of output
HL_SHOW="${BOLD}${YELLOW}"    # Important prompts before roxctl commands

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

# demo_launch - displays and runs commands with inverse video highlighting
# Usage: demo_launch [-o output_file] command [args...]
demo_launch() {
    local output_file=""
    
    # Check for -o or --output flag
    if [[ "$1" == "-o" ]] || [[ "$1" == "--output" ]]; then
        output_file="$2"
        shift 2
    fi
    
    # Print command display to stderr (always visible)
    echo -e "\e[1;93m▶▶▶\e[0m \e[1m\e[7m$*\e[0m" >&2
    
    # Execute with or without output redirection
    if [[ -n "$output_file" ]]; then
        "$@" > "$output_file"
    else
        "$@"
    fi
    
    # Reset formatting (to stderr)
    echo -e '\e[0m' >&2
}

# demo_show - displays highlighted text
# Usage: demo_show "message"
demo_show() {
    echo -e "${HL_SHOW}$*${NC}"
}

# demo_prompt - interactive prompt that waits for keypress
# Usage: demo_prompt "prompt text"
demo_prompt() {
    read -n 1 -s -p "$*"
    echo
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
rm -f ../DOT/explain.txt

cat <<EOF

####################################################################
# Use Case 1 - Generate Network Policies and visualize connectivity
####################################################################
EOF
demo_prompt "Show the Online Boutique application ..."
pop_chrome "Online Boutique"

echo
demo_prompt "======  Step 1: Generate network policies ! ======"
echo
demo_show "▶ Generating network policies with roxctl..."
demo_launch roxctl netpol generate --dnsport 5353 . --remove -f ../NETPOL/network-policies.yaml
echo
demo_prompt "view the generated network policies ..."
less ../NETPOL/network-policies.yaml
## DO show the network policies (less ../NETPOL/network-policies.yaml)
#  SAY call out 
# 1. default deny
# 2. match egress with ingress
# 3. opened  dns ports 
echo
demo_prompt "show generated  policies in slide ..."
echo
pop_chrome "Demonstration of Automatic Kubernetes Network Policies"
echo
demo_prompt "Test IP connectivity before applying network policies ..."
echo
PAYMENT_IP=$(oc get svc -n ms-demo paymentservice -o jsonpath='{.spec.clusterIP}')
demo_show "FROM: adservice TO: Paymentservice IP: $PAYMENT_IP"
echo
demo_launch oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}✓ Connection is ALLOWED${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
demo_prompt "Apply network policies to cluster ..."
echo
demo_launch oc apply -f  ../NETPOL/network-policies.yaml
echo
demo_prompt "Test IP connectivity after applying network policies ..."
echo
demo_launch oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
echo
echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${RED}✗ Connection is BLOCKED${NC}"
echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
demo_prompt "Show network policies in OCP console ..."
echo
pop_chrome "NetworkPolicies"
read -n 1 -s -p 'Show the app still works :-) '
pop_chrome "Online Boutique"
echo
echo
demo_prompt "======  Step 2: Generate explicit connectivity map ! ======"
echo
echo
demo_show "▶ Generating connectivity map with roxctl..."
demo_launch -o /dev/null roxctl netpol connectivity map .. -o dot -f ../DOT/connectivity-map.dot
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/connectivity-map.dot
echo
demo_prompt "Show connectivity map ... "
xdot -g 1400x900 ../DOT/connectivity-map.dot >/dev/null 2>&1  &
echo

demo_prompt "on to Use Case 2 ... "
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
demo_prompt   " apply the AdminNetworkPolicy ..."
echo
demo_launch oc apply -f ../NETPOL/ANP-add-monitoring-with-ports-to-all-NS.yaml
demo_prompt "See ANP in OpenShift Console"
echo
pop_chrome "adminnetworkpolicies"
demo_prompt "======  Step 3: Analyze exposure with focus on frontend ======"
echo
echo
demo_show "▶ Analyzing exposure with roxctl..."
demo_launch -o /dev/null roxctl netpol connectivity map .. --focus-workload frontend --exposure  -o dot -f ../DOT/frontend-connectivity-map.dot --remove
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
demo_prompt "Show connectivity map ... "
xdot -g 1400x900 ../DOT/frontend-connectivity-map.dot  >/dev/null 2>&1 &
echo

demo_prompt "on to Use Case 3 ... "
echo
pop_chrome "Demonstration of Automatic Kubernetes Network Policies"

clear
cat <<EOF
########################################################
# Use Case 3 - Why are my apps not talking nor over exposed?
########################################################
EOF
demo_prompt "======  Step 4: Explain connectivity for frontend ======"
echo
demo_show "▶ Generating connectivity explanation with roxctl..."
demo_launch -o ../DOT/explain.txt roxctl netpol connectivity map .. --focus-workload frontend --explain
echo
demo_prompt "Show connectivity explanation ... "
less -S ../DOT/explain.txt
echo
demo_prompt "With a littel help from Cursor (CMD ^ V) "
echo
open ../DOT/05-frontend-connectivity-summary.md
echo
demo_prompt "Back to slides ... "
pop_chrome "Google Slides"
echo
demo_prompt "End of Demo 3 ... "
echo
clear
cat <<EOF
########################################################
# DEMO 4 - Diff between network policies in two different folders
########################################################
EOF
