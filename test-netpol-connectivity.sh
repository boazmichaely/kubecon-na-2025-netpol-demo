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

# Customize the trace prompt (PS4) to highlight traced commands
export PS4=$'\e[1;93m▶▶▶ \e[0m'

echo "Network Policy Connectivity Test"
echo "=================================="
echo

read -n 1 -s -p "Step 1: Delete network policies ..."
echo
export PS4='+ '
set -x
oc delete -f ../NETPOL/network-policies.yaml 2>/dev/null
{ set +x; } 2>/dev/null
echo

read -n 1 -s -p "Step 2: Test connectivity before applying network policies ..."
echo
PAYMENT_IP=$(oc get svc -n ms-demo paymentservice -o jsonpath='{.spec.clusterIP}')
echo "Paymentservice IP: $PAYMENT_IP"
echo
export PS4=$'\e[1;93m▶▶▶ '
set -x
oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
{ set +x; } 2>/dev/null
echo
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}✓ Connection is ALLOWED${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

read -n 1 -s -p "Step 3: Apply network policies ..."
echo
export PS4='+ '
set -x
oc apply -f ../NETPOL/network-policies.yaml
{ set +x; } 2>/dev/null
echo

read -n 1 -s -p "Step 4: Test connectivity after applying network policies ..."
echo
echo "Testing with same IP: $PAYMENT_IP"
echo
export PS4='+ '
set -x
oc exec -n ms-demo deployment/adservice -- sh -c "nc -zv -w 3 $PAYMENT_IP 50051"
{ set +x; } 2>/dev/null || true
echo
echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${RED}✗ Connection is BLOCKED${NC}"
echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
