#!/bin/bash

set -e

echo "Deploying httpbin..."

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl not found"
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    echo "Error: Cannot connect to cluster"
    exit 1
fi

echo "Connected to: $(kubectl config current-context)"

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Waiting for deployment..."
kubectl wait --for=condition=available --timeout=300s deployment/httpbin -n httpbin-demo

echo "Deployment complete"
kubectl get pods -n httpbin-demo
