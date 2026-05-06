#!/bin/bash

# Docker Engine + Docker Compose Plugin 설치 스크립트
# 대상 환경: Ubuntu 기반 클라우드 VM

set -e

echo "1. 기존 패키지 인덱스 업데이트"
sudo apt-get update

echo "2. Docker 저장소 접근을 위한 필수 패키지 설치"
sudo apt-get install -y ca-certificates curl gnupg

echo "3. Docker 공식 GPG 키 저장 디렉터리 생성"
sudo install -m 0755 -d /etc/apt/keyrings

echo "4. Docker 공식 GPG 키 다운로드"
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "5. GPG 키 권한 설정"
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "6. Docker 공식 APT 저장소 추가"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "7. Docker 저장소 추가 후 패키지 인덱스 재업데이트"
sudo apt-get update

echo "8. Docker Engine, CLI, Container Runtime, Buildx, Compose Plugin 설치"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "9. Docker 서비스 시작 및 부팅 시 자동 실행 설정"
sudo systemctl enable docker
sudo systemctl start docker

echo "10. Docker 설치 확인"
sudo docker --version

echo "11. Docker Compose 설치 확인"
docker compose version || sudo docker compose version

echo "12. Docker 테스트 컨테이너 실행"
sudo docker run hello-world

echo "Docker Engine 및 Docker Compose 설치 완료"