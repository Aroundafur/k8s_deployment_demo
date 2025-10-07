#!/bin/bash

set -e

echo "Testing deployment..."

if ! kubectl get namespace httpbin-demo &> /dev/null; then
    echo "Error: Namespace not found. Run ./scripts/deploy.sh first"
    exit 1
fi

kubectl get pods -n httpbin-demo
kubectl wait --for=condition=ready pod -l app=httpbin -n httpbin-demo --timeout=60s

echo "Testing connectivity..."
kubectl port-forward service/httpbin-service 8080:80 -n httpbin-demo &
PF_PID=$!
sleep 2

if curl -s --max-time 5 http://localhost:8080/status/200 > /dev/null; then
    echo "PASS: /status/200"
else
    echo "FAIL: /status/200"
    kill $PF_PID 2>/dev/null || true
    exit 1
fi

if curl -s --max-time 5 http://localhost:8080/json | grep -q "slideshow"; then
    echo "PASS: /json"
else
    echo "FAIL: /json"
    kill $PF_PID 2>/dev/null || true
    exit 1
fi

kill $PF_PID 2>/dev/null || true
echo "All tests passed"
