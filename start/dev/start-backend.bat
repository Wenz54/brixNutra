@echo off
echo ============================================
echo   Brix Nutrition Backend Server
echo ============================================
echo.
cd /d "%~dp0"
echo Current directory: %CD%
echo.
echo Starting server on http://localhost:3000
echo Press Ctrl+C to stop
echo.
npm run dev
pause


