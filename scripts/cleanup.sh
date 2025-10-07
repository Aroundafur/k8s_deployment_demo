#!/bin/bash

set -e

echo "Cleaning up..."

kubectl delete -f k8s/service.yaml --ignore-not-found=true
kubectl delete -f k8s/deployment.yaml --ignore-not-found=true  
kubectl delete -f k8s/namespace.yaml --ignore-not-found=true

echo "Cleanup complete"
