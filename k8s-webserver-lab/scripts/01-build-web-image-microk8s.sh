#!/bin/bash
set -e

# ============================================================
# Node.js Web 이미지를 빌드하고 MicroK8s containerd에 import
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE_NAME="kubernetes-lab-web:latest"
TAR_PATH="/tmp/kubernetes-lab-web.tar"

cd "$ROOT_DIR"

echo "[1/3] Docker image build: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" ./web

echo "[2/3] Docker image save: $TAR_PATH"
docker save "$IMAGE_NAME" -o "$TAR_PATH"

echo "[3/3] Import image into MicroK8s containerd"
sudo microk8s ctr image import "$TAR_PATH"

echo ""
echo "============================================================"
echo "Web image build/import 완료: $IMAGE_NAME"
echo "============================================================"
