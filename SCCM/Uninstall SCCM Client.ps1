# Author: Omar Osman Mahat
# Twitter: @thekingsmakers
# Description: This script completely uninstalls the SCCM client from a machine.
# Version: 1.0
# Function to stop services and processes related to SCCM
function Stop-SCCMServices {
    $services = @("CcmExec", "smstsmgr", "CcmSetup")
    foreach ($service in $services) {
        if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Write-Host "Stopped service: $service" -ForegroundColor Green
        }
    }
    Get-Process -Name "CcmExec", "CcmSetup" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "Stopped related processes." -ForegroundColor Green
}
 
# Function to remove SCCM client files and folders
function Remove-SCCMFiles {
    $paths = @(
        "C:\\Windows\\ccm",
        "C:\\Windows\\ccmsetup",
        "C:\\Windows\\ccmcache",
        "C:\\Windows\\SMSCFG.INI"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                Write-Host "Removed: $path" -ForegroundColor Green
            } catch {
                Write-Host "Failed to remove: $path" -ForegroundColor Red
            }
        } else {
            Write-Host "Path not found: $path" -ForegroundColor Yellow
        }
    }
}
 
# Function to clean registry entries related to SCCM
function Remove-SCCMRegistryEntries {
    $registryKeys = @(
        "HKLM:\\SOFTWARE\\Microsoft\\CCM",
        "HKLM:\\SOFTWARE\\Microsoft\\SMS",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\CCMExec",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\CcmSetup"
    )
    foreach ($key in $registryKeys) {
        if (Test-Path $key) {
            try {
                Remove-Item -Path $key -Recurse -Force -ErrorAction Stop
                Write-Host "Removed registry key: $key" -ForegroundColor Green
            } catch {
                Write-Host "Failed to remove registry key: $key" -ForegroundColor Red
            }
        } else {
            Write-Host "Registry key not found: $key" -ForegroundColor Yellow
        }
    }
}
 
# Main Script Execution
Write-Host "Starting SCCM Client Uninstallation Process..." -ForegroundColor Green
 
# Step 1: Stop SCCM Services and Processes
Write-Host "Stopping SCCM-related services and processes..." -ForegroundColor Yellow
Stop-SCCMServices
 
# Step 2: Uninstall SCCM Client
Write-Host "Running SCCM Client uninstallation command..." -ForegroundColor Yellow
$ccmSetupPath = "C:\\Windows\\ccmsetup\\ccmsetup.exe"
if (Test-Path $ccmSetupPath) {
    try {
        Start-Process -FilePath $ccmSetupPath -ArgumentList "/uninstall" -Wait -NoNewWindow
        Write-Host "SCCM Client uninstallation command executed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error executing uninstallation command: $_" -ForegroundColor Red
    }
} else {
    Write-Host "SCCM Client uninstall command not found at: $ccmSetupPath. Skipping..." -ForegroundColor Yellow
}
 
# Step 3: Remove SCCM Files and Folders
Write-Host "Removing SCCM-related files and folders..." -ForegroundColor Yellow
Remove-SCCMFiles
 
# Step 4: Clean Registry Entries
Write-Host "Cleaning SCCM-related registry entries..." -ForegroundColor Yellow
Remove-SCCMRegistryEntries
 
# Step 5: Confirm Completion
Write-Host "SCCM Client uninstallation process completed." -ForegroundColor Green
