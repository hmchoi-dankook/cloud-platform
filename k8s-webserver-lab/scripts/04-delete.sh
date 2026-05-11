#!/bin/bash
set -e

# ============================================================
# Kubernetes Lab 삭제 스크립트
# 주의: namespace를 삭제하므로 PVC와 PostgreSQL 데이터도 함께 삭제됨
# ============================================================

KUBECTL="${KUBECTL:-microk8s kubectl}"

$KUBECTL delete namespace kubernetes-lab --ignore-not-found=true

echo ""
echo "============================================================"
echo "kubernetes-lab namespace 삭제 요청 완료"
echo "PVC도 함께 삭제되므로 PostgreSQL 데이터가 초기화됩니다."
echo "============================================================"
