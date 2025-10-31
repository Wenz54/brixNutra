@echo off
echo ============================================
echo   Brix Backend - Start and Test
echo ============================================
echo.
cd /d "%~dp0"

echo [1/4] Starting server...
start "Brix Backend Server" /MIN cmd /k "npx tsx src/index.ts"

echo [2/4] Waiting 12 seconds for startup...
timeout /t 12 /nobreak >nul

echo [3/4] Testing API endpoints...
echo.

echo ---  GET /health  ---
curl -s http://localhost:3000/health
echo.
echo.

echo ---  GET /api  ---
curl -s http://localhost:3000/api
echo.
echo.

echo [4/4] Server Info:
echo     - Running in separate window (minimized)
echo     - Swagger UI: http://localhost:3000/documentation
echo     - Mailhog: http://localhost:8025
echo.
echo ============================================
echo.
echo Server is running! Open your browser:
echo http://localhost:3000/documentation
echo.
echo Press any key to STOP the server and exit...
pause >nul

echo.
echo Stopping server...
taskkill /FI "WINDOWTITLE eq Brix Backend Server*" /F >nul 2>&1
echo Done!


