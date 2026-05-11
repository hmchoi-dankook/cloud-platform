#!/bin/bash
set -e

# ============================================================
# Kubernetes Lab 상태 확인 스크립트
# ============================================================

# MicroK8s 권한 문제 방지를 위해 sudo 포함
KUBECTL=(sudo microk8s kubectl)

echo "============================================================"
echo "Kubernetes Lab 상태 확인"
echo "============================================================"

echo ""
echo "--- All Resources ---"
"${KUBECTL[@]}" get all -n kubernetes-lab

echo ""
echo "--- PVC ---"
"${KUBECTL[@]}" get pvc -n kubernetes-lab

echo ""
echo "--- Pods wide ---"
"${KUBECTL[@]}" get pods -n kubernetes-lab -o wide

echo ""
echo "--- Services ---"
"${KUBECTL[@]}" get services -n kubernetes-lab