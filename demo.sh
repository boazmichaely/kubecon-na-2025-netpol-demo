#!/usr/bin/env bash
{ set +x; } 2>/dev/null
clear
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
# - demo3: diff 
# - demo4: explainability (combined with AI)
#
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
rm -f ../NETPOL/network-policies.yaml
rm -f ../DOT/connectivity-map.dot

########################################################
# DEMO 1 
########################################################

read -n 1 -s -p "Show the Online Boutique application ..."
echo
read -n 1 -s -p "Generate network policies ! ..."
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
read -n 1 -s -p "Apply network policies to cluster ..."
echo
set -x
oc apply -f  ../NETPOL/network-policies.yaml
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "Show network policies in OCP console ..."
echo
read -n 1 -s -p 'Show the app still works :-) '
echo
read -n 1 -s -p "3. ** Generate connectivity map ! ... "
echo
set -x
roxctl netpol connectivity map .. -o dot -f ../DOT/connectivity-map.dot >/dev/null 
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/connectivity-map.dot
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "4. Show connectivity map in VSCode ... "
echo

########################################################
# DEMO 2
########################################################
echo
echo "#########  Demo 2  #########"
read -n 1 -s -p "How tight are the policies? Analyze exposure with focus on frontend ... "
echo
set -x
roxctl netpol connectivity map .. --focus-workload frontend --exposure  -o dot -f ../DOT/frontend-connectivity-map.dot --remove >/dev/null 
sed -i '' 's/="green"/="#00FF00"/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/="gold2"/="#00FF00"/g' ../DOT/frontend-connectivity-map.dot
sed -i '' 's/="darkorange2"/="#FF0000"/g' ../DOT/frontend-connectivity-map.dot
{ set +x; } 2>/dev/null
echo
read -n 1 -s -p "Show connectivity map in VSCode ... "
echo
