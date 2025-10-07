@echo off
REM HTTPBin Kubernetes Cleanup Script for Windows
REM Removes HTTPBin deployment from cluster

echo Cleaning up HTTPBin deployment...

echo Checking if namespace exists...
kubectl get namespace httpbin-demo >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo HTTPBin namespace not found. Nothing to clean up.
    exit /b 0
)

echo Deleting namespace and all resources...
kubectl delete namespace httpbin-demo

echo Waiting for cleanup to complete...
:wait_loop
kubectl get namespace httpbin-demo >nul 2>&1
if %ERRORLEVEL% equ 0 (
    timeout /t 2 /nobreak >nul
    goto wait_loop
)

echo.
echo Cleanup completed successfully!
echo.