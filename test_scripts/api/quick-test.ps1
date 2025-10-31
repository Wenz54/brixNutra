# Quick Backend Test
Write-Host "Starting Brix Backend..." -ForegroundColor Green

Set-Location $PSScriptRoot

# Start server
$job = Start-Job -ScriptBlock {
    Set-Location $args[0]
    npx tsx src/index.ts 2>&1
} -ArgumentList $PSScriptRoot

Write-Host "Waiting 10 seconds for server to start..."
Start-Sleep -Seconds 10

# Check port
$listening = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($listening) {
    Write-Host "Server is running on port 3000!" -ForegroundColor Green
    
    # Test health
    try {
        $health = Invoke-RestMethod -Uri "http://localhost:3000/health" -TimeoutSec 5
        Write-Host "Health Check: PASSED" -ForegroundColor Green
        $health | ConvertTo-Json
    } catch {
        Write-Host "Health Check: FAILED - $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test API
    try {
        $api = Invoke-RestMethod -Uri "http://localhost:3000/api" -TimeoutSec 5
        Write-Host "API Info: PASSED" -ForegroundColor Green
        $api | ConvertTo-Json
    } catch {
        Write-Host "API Info: FAILED" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Swagger: http://localhost:3000/documentation"
    Write-Host "Press Enter to stop..."
    Read-Host
    
} else {
    Write-Host "Server NOT running!" -ForegroundColor Red
    Receive-Job -Job $job
}

Stop-Job -Job $job -ErrorAction SilentlyContinue
Remove-Job -Job $job -Force -ErrorAction SilentlyContinue


