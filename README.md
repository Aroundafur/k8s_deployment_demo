# HTTPBin Kubernetes Deployment

A Kubernetes deployment of HTTPBin with security best practices and high availability configuration.

## Features

- 3 replica deployment with anti-affinity rules
- Security hardening (non-root containers, restricted capabilities)
- Resource limits and health checks
- Multiple service types (LoadBalancer, NodePort)

## Requirements

- Minikube
- kubectl
- curl (or PowerShell's Invoke-WebRequest on Windows)

## Setup

### macOS
```bash
brew install minikube kubectl
minikube start
```

### Linux
```bash
# Ubuntu/Debian
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo snap install kubectl --classic

# CentOS/RHEL/Fedora
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo dnf install kubectl

# Arch Linux
sudo pacman -S minikube kubectl

# Start Minikube
minikube start
```

### Windows
```powershell
# Option 1: Using Chocolatey
choco install minikube kubernetes-cli

# Option 2: Using Scoop
scoop install minikube kubectl

# Option 3: Manual installation
# Download from GitHub releases:
# - Minikube: https://github.com/kubernetes/minikube/releases
# - kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

# Start Minikube
minikube start
```

## Usage

### macOS & Linux

Deploy:
```bash
./scripts/deploy.sh
```

Test:
```bash
./scripts/verify.sh
```

Clean up:
```bash
./scripts/cleanup.sh
```

### Windows

Deploy:
```batch
scripts\deploy.bat
```

Test:
```batch
scripts\verify.bat
```

Clean up:
```batch
scripts\cleanup.bat
```

Or manually:
```powershell
# Deploy manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment
kubectl wait --for=condition=available deployment/httpbin-deployment -n httpbin-demo --timeout=300s
```

## Cross-Platform Access

### Port Forward (All Platforms)
```bash
# Start port-forward (keeps running until Ctrl+C)
kubectl port-forward service/httpbin-service 8080:80 -n httpbin-demo

# Then visit http://localhost:8080 in browser
```

Test with curl (macOS/Linux):
```bash
curl http://localhost:8080/json
curl http://localhost:8080/ip
curl http://localhost:8080/status/200
```

Test with PowerShell (Windows):
```powershell
Invoke-WebRequest -Uri "http://localhost:8080/json"
Invoke-WebRequest -Uri "http://localhost:8080/ip" 
Invoke-WebRequest -Uri "http://localhost:8080/status/200"
```

### Minikube Service (All Platforms)
```bash
# Opens browser automatically
minikube service httpbin-nodeport -n httpbin-demo
```

### NodePort Access (All Platforms)
```bash
# Get Minikube IP
minikube ip

# Then access http://<MINIKUBE-IP>:30080 in browser
```

## Project Structure

```
k8s_deployment_demo/
├── k8s/
│   ├── namespace.yaml        # Namespace definition
│   ├── deployment.yaml       # HTTPBin deployment
│   └── service.yaml          # Services
├── scripts/
│   ├── deploy.sh            # Deploy script (macOS/Linux)
│   ├── deploy.bat           # Deploy script (Windows)
│   ├── verify.sh            # Test script (macOS/Linux)
│   ├── verify.bat           # Test script (Windows)
│   ├── cleanup.sh           # Cleanup script (macOS/Linux)
│   └── cleanup.bat          # Cleanup script (Windows)
└── README.md                # This file
```

## Configuration

### Deployment
- 3 replicas with anti-affinity distribution
- Rolling updates with controlled rollout
- Resource limits: CPU 200m, Memory 128Mi
- Health checks on `/status/200`

### Security
- Non-root containers (user 1000)
- Minimal capabilities (NET_BIND_SERVICE only)
- seccomp profile enabled

## Testing

Test endpoints:
- `/status/200` - Status check
- `/json` - JSON response  
- `/ip` - Client IP
- `/headers` - Request headers

## Monitoring

```bash
kubectl get pods -n httpbin-demo
kubectl logs -l app=httpbin -n httpbin-demo
```

## Scaling

```bash
kubectl scale deployment httpbin --replicas=5 -n httpbin-demo
```

## HTTPBin Endpoints

- `/status/200` - Status check
- `/json` - JSON response
- `/ip` - Client IP
- `/headers` - Request headers
- `/get`, `/post`, `/put`, `/delete` - HTTP methods

See [httpbin.org](https://httpbin.org/) for complete documentation.