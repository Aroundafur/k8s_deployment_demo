@echo off
REM HTTPBin Kubernetes Verification Script for Windows
REM Tests HTTPBin deployment functionality

echo Testing HTTPBin deployment...

echo Checking if deployment is ready...
kubectl get deployment httpbin-deployment -n httpbin-demo >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo HTTPBin deployment not found. Run deploy.bat first.
    exit /b 1
)

echo Starting port-forward...
start /b kubectl port-forward service/httpbin-service 8080:80 -n httpbin-demo

echo Waiting for port-forward to establish...
timeout /t 3 /nobreak >nul

echo.
echo Testing endpoints:

echo Testing /status/200...
powershell -command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/status/200' -TimeoutSec 10; Write-Host 'Status endpoint: OK' } catch { Write-Host 'Status endpoint: FAILED'; exit 1 }"
if %ERRORLEVEL% neq 0 exit /b 1

echo Testing /json...
powershell -command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/json' -TimeoutSec 10; Write-Host 'JSON endpoint: OK' } catch { Write-Host 'JSON endpoint: FAILED'; exit 1 }"
if %ERRORLEVEL% neq 0 exit /b 1

echo Testing /ip...
powershell -command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/ip' -TimeoutSec 10; Write-Host 'IP endpoint: OK' } catch { Write-Host 'IP endpoint: FAILED'; exit 1 }"
if %ERRORLEVEL% neq 0 exit /b 1

echo.
echo Stopping port-forward...
taskkill /f /im kubectl.exe >nul 2>&1

echo.
echo All tests passed! HTTPBin deployment is working correctly.
echo Access via: minikube service httpbin-nodeport -n httpbin-demo
echo.