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
- curl

## Setup

Install and start Minikube:
```bash
brew install minikube
minikube start
```

## Usage

Deploy:
```bash
./scripts/deploy.sh
```

Test:
```bash
./scripts/verify.sh
```

Access:
```bash
# Start port-forward (keeps running until Ctrl+C)
kubectl port-forward service/httpbin-service 8080:80 -n httpbin-demo

# Then visit http://localhost:8080 in browser or:
curl http://localhost:8080/json
curl http://localhost:8080/ip
curl http://localhost:8080/status/200
```

Alternative access methods:
```bash
# Via Minikube service (opens browser automatically)
minikube service httpbin-nodeport -n httpbin-demo

# Via NodePort (get Minikube IP first)
minikube ip
# Then access http://<MINIKUBE-IP>:30080
```

Clean up:
```bash
./scripts/cleanup.sh
```

## Project Structure

```
k8s_deployment_demo/
├── k8s/
│   ├── namespace.yaml        # Namespace definition
│   ├── deployment.yaml       # HTTPBin deployment
│   └── service.yaml          # Services
├── scripts/
│   ├── deploy.sh            # Deploy script
│   ├── verify.sh            # Test script
│   └── cleanup.sh           # Cleanup script
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