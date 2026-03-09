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

# OCP Cluster Configuration
OCP_CLUSTER_URL="console-openshift-console.apps.bm-customer-demo.ocp.infra.rox.systems"
# FRONTEND_URL format: https://frontend-ms-demo.apps.<apps-domain>/
OCP_APPS_DOMAIN="${OCP_CLUSTER_URL#*apps.}"
FRONTEND_URL="https://frontend-ms-demo.apps.${OCP_APPS_DOMAIN}/"

# Slide deck title (for pop_chrome to find the correct window)
SLIDES_TITLE="2026-03-09 Demonstration of roxctl netpol"

# OCP Console: identify tabs by URL path (tab identifier "console-openshift-console" in host)
OCP_CONSOLE_BASE="https://${OCP_CLUSTER_URL}"
OCP_NETPOL_URL="${OCP_CONSOLE_BASE}/k8s/all-namespaces/networking.k8s.io~v1~NetworkPolicy"
OCP_ANP_URL="${OCP_CONSOLE_BASE}/k8s/cluster/customresourcedefinitions/adminnetworkpolicies.policy.networking.k8s.io/instances?page=1&perPage=50"
# URL substrings to find the right tab (match by path, not title)
OCP_NETPOL_URL_MATCH="networking.k8s.io~v1~NetworkPolicy"
OCP_ANP_URL_MATCH="adminnetworkpolicies.policy.networking.k8s.io"
# ms-demo workloads (list view) — verify store project is installed
OCP_MS_DEMO_WORKLOADS_URL="${OCP_CONSOLE_BASE}/k8s/cluster/projects/ms-demo/workloads?view=list"
OCP_MS_DEMO_WORKLOADS_URL_MATCH="projects/ms-demo/workloads"

# Default folder to open in VSCode
#VSCODE_DEFAULT_FOLDER="./kubernetes-manifests"
VSCODE_DEFAULT_FOLDER=".."

# Helper function to open the store frontend
open_store() {
    echo -e "${CYAN}Opening store frontend: ${FRONTEND_URL}${NC}"
    open "$FRONTEND_URL"
}

# Helper function to bring VSCode to front, or open a folder in VSCode
# Usage: pop_vscode [folder]
#   No args: just activate VSCode (bring to front), do not open a new window.
#   With folder: open that folder in VSCode (default from demo is VSCODE_DEFAULT_FOLDER when passed explicitly).
pop_vscode() {
    if [ -n "$1" ]; then
        open -a "Visual Studio Code" "$1"
    else
        osascript -e 'tell application "Visual Studio Code" to activate'
    fi
}

# Highlight definitions for different types of output
HL_SHOW="${BOLD}${YELLOW}"    # Important prompts before roxctl commands

# Helper function to bring Chrome to front
# Usage: pop_chrome "tab title substring" [url_contains]
#   If url_contains is set, only matches tabs whose URL contains that string (e.g. "openshift-console" for OCP).
#   Use this for OCP console so we don't match a slides tab whose slide title happens to match.
pop_chrome() {
    if [ -z "$1" ]; then
        # No window name - just activate Chrome
        osascript -e 'tell application "Google Chrome" to activate'
    else
        local title="$1"
        local url_filter="${2:-}"
        if [ -n "$url_filter" ]; then
            # Match both title and URL so we don't grab the slides tab when it shows "NetworkPolicies" etc.
            osascript <<EOF
tell application "Google Chrome"
    activate
    delay 0.1
    repeat with w in windows
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if title of t contains "$title" and (URL of t contains "$url_filter") then
                set active tab index of w to tabIndex
                set index of w to 1
                tell application "System Events"
                    tell process "Google Chrome"
                        perform action "AXRaise" of window 1
                    end tell
                end tell
                return
            end if
        end repeat
    end repeat
end tell
EOF
        else
            osascript <<EOF
tell application "Google Chrome"
    activate
    delay 0.1
    repeat with w in windows
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if title of t contains "$title" then
                set active tab index of w to tabIndex
                set index of w to 1
                tell application "System Events"
                    tell process "Google Chrome"
                        perform action "AXRaise" of window 1
                    end tell
                end tell
                return
            end if
        end repeat
    end repeat
end tell
EOF
        fi
    fi
}

# Bring Chrome tab to front by URL substring; if not found and open_url is set, open that URL.
# Usage: pop_chrome_by_url "url_contains" [open_url_if_not_found]
#   Tab identifier: use "console-openshift-console" in host; path fragments identify NetPol vs ANP.
pop_chrome_by_url() {
    local url_contains="$1"
    local open_url="${2:-}"
    local found
    found=$(osascript 2>/dev/null <<EOF
tell application "Google Chrome"
    set tabFound to false
    activate
    delay 0.1
    repeat with w in windows
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if (URL of t contains "$url_contains") then
                set tabFound to true
                set active tab index of w to tabIndex
                set index of w to 1
                tell application "System Events"
                    tell process "Google Chrome"
                        perform action "AXRaise" of window 1
                    end tell
                end tell
                return "found"
            end if
        end repeat
    end repeat
    return "not found"
end tell
EOF
    )
    if [ "$found" != "found" ] && [ -n "$open_url" ]; then
        open "$open_url"
    fi
}

# Returns 0 if Chrome has a tab whose title contains the given string, 1 otherwise.
# Usage: chrome_tab_exists "tab title substring"
chrome_tab_exists() {
    local title="$1"
    local result
    result=$(osascript 2>/dev/null <<EOF
tell application "Google Chrome"
    set tabFound to false
    repeat with w in windows
        repeat with t in tabs of w
            if title of t contains "$title" then
                set tabFound to true
                exit repeat
            end if
        end repeat
        if tabFound then exit repeat
    end repeat
    return tabFound
end tell
EOF
    )
    [ "$result" = "true" ]
}

# Test demo preconditions: OC login/project, store reachable, slides tab open.
# Usage: test_demo_conditions
test_demo_conditions() {
    echo -e "${BOLD}Demo condition checks${NC}"
    echo

    # 1. OC logged-in user and project (must be ms-demo)
    echo -e "${BOLD}1. OpenShift (oc)${NC}"
    local oc_user oc_project
    oc_user=$(oc whoami 2>/dev/null) || true
    oc_project=$(oc project -q 2>/dev/null) || true
    if [ -z "$oc_user" ]; then
        echo -e "   User:    ${RED}(not logged in)${NC}"
        echo -e "   Project: ${RED}(unknown)${NC}"
        echo -e "   ${RED}FAIL${NC} — log in with: oc login ..."
    else
        echo -e "   User:    ${CYAN}${oc_user}${NC}"
        echo -e "   Project: ${CYAN}${oc_project}${NC}"
        if [ "$oc_project" = "ms-demo" ]; then
            echo -e "   ${GREEN}OK${NC} — project is ms-demo"
        else
            echo -e "   ${RED}FAIL${NC} — project should be ms-demo (e.g. oc project ms-demo)"
        fi
    fi
    echo

    # 2. Open store and check if reachable
    echo -e "${BOLD}2. Store frontend${NC}"
    echo -e "   Opening: ${CYAN}${FRONTEND_URL}${NC}"
    open "$FRONTEND_URL" 2>/dev/null || true
    sleep 2
    local code
    code=$(curl -s -L -k -o /dev/null -w "%{http_code}" --connect-timeout 10 "$FRONTEND_URL" 2>/dev/null) || code=""
    if [[ "$code" = 2* ]]; then
        echo -e "   ${GREEN}OK${NC} — store reachable (HTTP ${code})"
    else
        echo -e "   ${RED}FAIL${NC} — store not reachable (HTTP ${code:-timeout/error})"
    fi
    echo

    # 3. Slides tab (Chrome)
    echo -e "${BOLD}3. Slides tab${NC}"
    echo -e "   Looking for tab title containing: ${CYAN}${SLIDES_TITLE}${NC}"
    if chrome_tab_exists "$SLIDES_TITLE"; then
        echo -e "   ${GREEN}OK${NC} — tab found, bringing to front"
        pop_chrome "$SLIDES_TITLE"
    else
        echo -e "   ${RED}FAIL${NC} — no Chrome tab with that title. Open the slide deck and set SLIDES_TITLE in demo.sh to match."
    fi
    echo

    # 4. OCP console — ms-demo workloads (so you can see the store project is installed)
    echo -e "${BOLD}4. OCP console (ms-demo workloads)${NC}"
    echo -e "   Opening: ${CYAN}${OCP_MS_DEMO_WORKLOADS_URL}${NC}"
    local console_found
    console_found=$(osascript 2>/dev/null <<EOF
tell application "Google Chrome"
    set tabFound to false
    repeat with w in windows
        repeat with t in tabs of w
            if (URL of t contains "projects/ms-demo/workloads") then
                set tabFound to true
                return "found"
            end if
        end repeat
    end repeat
    return "not found"
end tell
EOF
    )
    if [ "$console_found" = "found" ]; then
        echo -e "   ${GREEN}OK${NC} — tab found, bringing to front"
        pop_chrome_by_url "$OCP_MS_DEMO_WORKLOADS_URL_MATCH" ""
    else
        open "$OCP_MS_DEMO_WORKLOADS_URL" 2>/dev/null || true
        echo -e "   ${GREEN}OK${NC} — opened console to ms-demo workloads (verify store project is installed)"
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
## DO show the web page https://frontend-ms-demo.apps.<OCP Cluster URL> 
## DO SHOP for a few seconds
# SAY let's generate tight network policies for the application
## DO 

########################################################
# Command-line options
########################################################
usage() {
    echo -e "${BOLD}Usage:${NC} ../demo.sh [command]   ${RED}(run from inside microservices-demo)${NC}"
    echo
    echo -e "${BOLD}Setup:${NC}"
    echo -e "  1. Be in the folder ${CYAN}microservices-demo${NC} and run the demo as ${CYAN}../demo.sh${NC}"
    echo -e "  2. Set up the OCP cluster (oc login, oc new-project ms-demo, oc apply -f application.yaml). See README."
    echo -e "  3. Set ${CYAN}SLIDES_TITLE${NC} in demo.sh to match your slide deck’s browser tab title, and have that tab open in Chrome."
    echo
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  ${CYAN}(none)${NC}           Show this help (default)"
    echo -e "  ${CYAN}run${NC}              Run the full demo step by step"
    echo -e "  ${CYAN}store${NC}            Open the Online Boutique store frontend in browser"
    echo -e "  ${CYAN}console-netpol${NC}   Bring OCP NetworkPolicies tab to front (or open URL)"
    echo -e "  ${CYAN}console-anp${NC}      Bring OCP AdminNetworkPolicies tab to front (or open URL)"
    echo -e "  ${CYAN}pop <tab>${NC}        Bring Chrome tab containing <tab> in title to front"
    echo -e "  ${CYAN}vscode [folder]${NC}  Open folder in VSCode (default: ${VSCODE_DEFAULT_FOLDER})"
    echo -e "  ${CYAN}test${NC}            Check demo conditions (oc, store, slides tab)"
    echo -e "  ${CYAN}help${NC}             Show this help message"
    echo
    echo -e "${BOLD}Current configuration:${NC}"
    echo -e "  OCP Cluster:    ${CYAN}${OCP_CLUSTER_URL}${NC}"
    echo -e "  Slides title:   ${CYAN}${SLIDES_TITLE}${NC}"
    echo -e "  Store URL:      ${CYAN}${FRONTEND_URL}${NC}"
    echo -e "  Console NetPol: ${CYAN}${OCP_NETPOL_URL}${NC}"
    echo -e "  Console ANP:    ${CYAN}${OCP_ANP_URL}${NC}"
    echo -e "  VSCode Folder:  ${CYAN}${VSCODE_DEFAULT_FOLDER}${NC}"
    echo
}

case "$1" in
    "")
        usage
        exit 0
        ;;
    run)
        # Run the demo (continue below)
        ;;
    store)
        open_store
        exit 0
        ;;
    console-netpol)
        pop_chrome_by_url "$OCP_NETPOL_URL_MATCH" "$OCP_NETPOL_URL"
        exit 0
        ;;
    console-anp)
        pop_chrome_by_url "$OCP_ANP_URL_MATCH" "$OCP_ANP_URL"
        exit 0
        ;;
    pop)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: pop requires a tab name${NC}"
            echo -e "Usage: ./demo.sh pop <tab>"
            exit 1
        fi
        pop_chrome "$2"
        exit 0
        ;;
    vscode)
        pop_vscode "$2"
        exit 0
        ;;
    test)
        test_demo_conditions
        exit 0
        ;;
    help|-h|--help)
        usage
        exit 0
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo
        usage
        exit 1
        ;;
esac

# Must be run from microservices-demo (as ../demo.sh). If not, show help and exit.
if [ ! -f application.yaml ] || [ ! -d kubernetes-manifests ]; then
    echo -e "${RED}Error: run this script from inside the microservices-demo folder, as ../demo.sh${NC}"
    echo
    usage
    exit 1
fi

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
# Online Boutique Application
####################################################################
EOF
demo_prompt "Show the Online Boutique application ..."
pop_chrome "Online Boutique"

demo_prompt "Show the YAML Resources ... "
pop_vscode

demo_prompt "back to slides "
pop_chrome "$SLIDES_TITLE"


cat <<EOF

####################################################################
# Use Case 1 - Generate Network Policies and visualize connectivity
####################################################################
EOF

echo
demo_prompt "======  Step 1: Generate network policies ! ======"
echo
demo_show "▶ Generating network policies with roxctl..."
demo_launch roxctl netpol generate --dnsport 5353 . --remove -f ../NETPOL/network-policies.yaml
echo

demo_prompt "view the generated network policies ..."
pop_vscode

demo_prompt "Let's take a closer look"
less ../NETPOL/network-policies.yaml

## DO show the network policies (less ../NETPOL/network-policies.yaml)
#  SAY call out 
# 1. default deny
# 2. match egress with ingress
# 3. opened  dns ports 
echo
demo_prompt "show generated  policies in slide ..."
echo
pop_chrome "$SLIDES_TITLE"
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
pop_chrome_by_url "$OCP_NETPOL_URL_MATCH" "$OCP_NETPOL_URL"
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
pop_chrome "$SLIDES_TITLE"

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
pop_chrome_by_url "$OCP_ANP_URL_MATCH" "$OCP_ANP_URL"
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
pop_chrome "$SLIDES_TITLE"

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
demo_prompt "With a little formatting help from AI (SHIFT CMD V) "
echo
open -a "Visual Studio Code" ../DOT/05-frontend-connectivity-summary.md
echo
demo_prompt "Back to slides ... "
pop_chrome "$SLIDES_TITLE"
echo
demo_prompt "End of Demo 3 ... "
echo
clear
cat <<EOF
########################################################
# DEMO 4 - Diff between network policies in two different folders
########################################################
EOF
