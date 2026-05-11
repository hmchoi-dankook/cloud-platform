#!/bin/bash
set -e

# ============================================================
# Kubernetes Lab 상태 확인 스크립트
# ============================================================

KUBECTL="${KUBECTL:-microk8s kubectl}"

$KUBECTL get all -n kubernetes-lab

echo ""
echo "--- PVC ---"
$KUBECTL get pvc -n kubernetes-lab

echo ""
echo "--- Pods wide ---"
$KUBECTL get pods -n kubernetes-lab -o wide

echo ""
echo "--- Services ---"
$KUBECTL get services -n kubernetes-lab
