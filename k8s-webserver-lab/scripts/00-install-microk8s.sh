#!/bin/bash
set -e

# ============================================================
# Ubuntu 환경에서 Kubernetes(MicroK8s) 설치 스크립트
# ============================================================

# 1. 패키지 인덱스 업데이트
sudo apt-get update

# 2. snapd 설치
sudo apt-get install -y snapd

# 3. MicroK8s 설치
sudo snap install microk8s --classic --channel=latest/stable

# 4. 현재 사용자를 microk8s 그룹에 추가
sudo usermod -a -G microk8s "$USER"

# 5. Kubernetes 설정 디렉터리 생성
mkdir -p ~/.kube
chmod 0700 ~/.kube

# 6. MicroK8s 준비 상태 확인
sudo microk8s status --wait-ready

# 7. 기본 애드온 활성화
sudo microk8s enable dns
sudo microk8s enable hostpath-storage

# 8. kubectl alias 등록
if ! grep -q "alias kubectl='microk8s kubectl'" ~/.bashrc; then
  echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
fi

# 9. 설치 확인
sudo microk8s kubectl get nodes

echo ""
echo "============================================================"
echo "MicroK8s 설치 완료"
echo "터미널을 재시작하거나 다음 명령어를 실행하세요:"
echo "  source ~/.bashrc"
echo "그룹 권한 적용을 위해 로그아웃 후 재로그인을 권장합니다."
echo "============================================================"
