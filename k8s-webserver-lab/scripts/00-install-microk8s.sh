#!/bin/bash
set -e

# ============================================================
# Ubuntu 환경에서 Kubernetes(MicroK8s) + Docker 설치 스크립트
# ============================================================

# 1. 패키지 인덱스 업데이트
sudo apt-get update

# 2. 기본 패키지 설치
sudo apt-get install -y snapd docker.io

# 3. Docker 서비스 활성화 및 시작
sudo systemctl enable docker
sudo systemctl start docker

# 4. 현재 사용자를 docker 그룹에 추가
# 이후 sudo 없이 docker 명령어 사용 가능
# 단, 그룹 권한은 로그아웃 후 재로그인해야 완전히 적용됨
sudo usermod -a -G docker "$USER"

# 5. MicroK8s 설치
# 이미 설치되어 있으면 건너뜀
if ! command -v microk8s >/dev/null 2>&1; then
  sudo snap install microk8s --classic --channel=latest/stable
else
  echo "MicroK8s가 이미 설치되어 있습니다."
fi

# 6. 현재 사용자를 microk8s 그룹에 추가
sudo usermod -a -G microk8s "$USER"

# 7. Kubernetes 설정 디렉터리 생성
mkdir -p ~/.kube
chmod 0700 ~/.kube
sudo chown -R "$USER":"$USER" ~/.kube

# 8. MicroK8s 준비 상태 확인
sudo microk8s status --wait-ready

# 9. 기본 애드온 활성화
# dns: Kubernetes Service 이름 기반 통신에 필요
# hostpath-storage: PostgreSQL PVC 사용에 필요
sudo microk8s enable dns
sudo microk8s enable hostpath-storage

# 10. kubectl alias 등록
if ! grep -q "alias kubectl='microk8s kubectl'" ~/.bashrc; then
  echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
fi

# 11. 설치 확인
echo ""
echo "Docker version:"
sudo docker version --format '{{.Server.Version}}'

echo ""
echo "Kubernetes nodes:"
sudo microk8s kubectl get nodes

echo ""
echo "============================================================"
echo "MicroK8s + Docker 설치 완료"
echo ""
echo "다음 명령어로 bash 설정을 다시 읽을 수 있습니다:"
echo "  source ~/.bashrc"
echo ""
echo "docker/microk8s 그룹 권한 적용을 위해 로그아웃 후 재로그인을 권장합니다."
echo ""
echo "다음 단계:"
echo "  bash scripts/01-build-web-image-microk8s.sh"
echo "  bash scripts/02-deploy.sh"
echo "============================================================"