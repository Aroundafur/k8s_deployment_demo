@echo off
REM HTTPBin Kubernetes Deployment Script for Windows
REM Deploys HTTPBin to Minikube cluster

echo Deploying HTTPBin to Kubernetes...

echo Applying namespace...
kubectl apply -f k8s/namespace.yaml
if %ERRORLEVEL% neq 0 (
    echo Error applying namespace
    exit /b 1
)

echo Applying deployment...
kubectl apply -f k8s/deployment.yaml
if %ERRORLEVEL% neq 0 (
    echo Error applying deployment
    exit /b 1
)

echo Applying service...
kubectl apply -f k8s/service.yaml
if %ERRORLEVEL% neq 0 (
    echo Error applying service
    exit /b 1
)

echo Waiting for deployment to be ready...
kubectl wait --for=condition=available deployment/httpbin-deployment -n httpbin-demo --timeout=300s
if %ERRORLEVEL% neq 0 (
    echo Deployment failed to become ready
    exit /b 1
)

echo.
echo Deployment successful!
echo.
echo Access the service:
echo   minikube service httpbin-nodeport -n httpbin-demo
echo   OR
echo   kubectl port-forward service/httpbin-service 8080:80 -n httpbin-demo
echo   Then visit: http://localhost:8080
echo.