# Kubernetes Lab: Nginx + Node.js + Redis + PostgreSQL

이 예제는 기존 `docker-compose-lab` 시나리오를 Kubernetes 방식으로 옮긴 실습 프로젝트입니다.

기존 Docker Compose 구조:

```text
nginx → web(Node.js) → redis / postgres
```

Kubernetes 구조:

```text
Browser
  ↓
nginx-service(NodePort:30080)
  ↓
nginx Pod
  ↓
web-service(ClusterIP:8080)
  ↓
web Pod x 2
  ↓                     ↓
redis-service:6379      postgres-service:5432
  ↓                     ↓
Redis Pod               PostgreSQL StatefulSet + PVC
```

## 1. MicroK8s 설치

```bash
chmod +x scripts/00-install-microk8s.sh
./scripts/00-install-microk8s.sh
```

설치 후 터미널을 재시작하거나 아래 명령어를 실행합니다.

```bash
source ~/.bashrc
```

## 2. Web 이미지 빌드 및 MicroK8s에 적재

```bash
chmod +x scripts/01-build-web-image-microk8s.sh
./scripts/01-build-web-image-microk8s.sh
```

## 3. Kubernetes 리소스 배포

```bash
chmod +x scripts/02-deploy.sh
./scripts/02-deploy.sh
```

또는 직접 실행:

```bash
microk8s kubectl apply -f k8s/00-namespace.yaml
microk8s kubectl apply -f k8s/
```

## 4. 상태 확인

```bash
chmod +x scripts/03-status.sh
./scripts/03-status.sh
```

주요 확인 명령어:

```bash
microk8s kubectl get all -n kubernetes-lab
microk8s kubectl get pvc -n kubernetes-lab
microk8s kubectl get pods -n kubernetes-lab -o wide
```

## 5. 접속

Ubuntu 서버 내부:

```bash
curl http://localhost:30080
```

외부 브라우저:

```text
http://<Ubuntu-서버-IP>:30080
```

## 6. 정리

```bash
chmod +x scripts/04-delete.sh
./scripts/04-delete.sh
```

주의: 이 스크립트는 PVC도 함께 삭제하므로 PostgreSQL 데이터가 초기화됩니다.

## Docker Compose 대비 변경점

| Docker Compose | Kubernetes |
|---|---|
| compose.yaml | k8s/*.yaml |
| service: nginx | nginx Deployment + Service |
| service: web | web Deployment + Service |
| service: redis | redis Deployment + Service |
| service: postgres | postgres StatefulSet + Service + PVC |
| environment | ConfigMap + Secret |
| volumes | PersistentVolumeClaim / ConfigMap mount |
| depends_on | initContainer + readinessProbe |
| web:8080 | web-service:8080 |
| postgres:5432 | postgres-service:5432 |
| redis:6379 | redis-service:6379 |
