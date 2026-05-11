#!/bin/bash
set -e

# ============================================================
# Kubernetes 리소스 배포 스크립트
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# MicroK8s 권한 문제 방지를 위해 sudo 포함
KUBECTL=(sudo microk8s kubectl)

cd "$ROOT_DIR"

echo "============================================================"
echo "Kubernetes 리소스 배포 시작"
echo "============================================================"

# namespace를 먼저 생성한 뒤 나머지 리소스 적용
"${KUBECTL[@]}" apply -f k8s/00-namespace.yaml
"${KUBECTL[@]}" apply -f k8s/

echo ""
echo "============================================================"
echo "배포 완료"
echo "상태 확인:"
echo "  sudo microk8s kubectl get all -n kubernetes-lab"
echo ""
echo "접속:"
echo "  curl http://localhost:30080"
echo "============================================================"