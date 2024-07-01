#=============================================================================================================================
#
# Script Name:     Remediate_TeamViewer.ps1
# Description:     Uninstall TeamViewer and remove related files and shortcuts
# Notes:           Script to uninstall TeamViewer from both x86 and x64 directories, delete related executables in user 
#                  directories, and remove shortcuts. Includes error handling and retry logic.
#
#=============================================================================================================================

# Define Variables and Paths
$teamViewerUninstallPaths = @("C:\Program Files\TeamViewer\uninstall.exe", "C:\Program Files (x86)\TeamViewer\uninstall.exe")
$fileNamePattern = "teamviewer*.exe"
$shortcutPaths = @([Environment]::GetFolderPath("CommonDesktopDirectory"), [Environment]::GetFolderPath("DesktopDirectory"), 
"$env:ProgramData\Microsoft\Windows\Start Menu\Programs")
$retryCount = 2

# Function Definitions
function DeleteFile ($path, $filePattern) {
    if (Test-Path $path) {
        $foundFiles = Get-ChildItem -Path $path -Recurse -Filter $filePattern -ErrorAction SilentlyContinue | Where-Object { 
!$_.PSIsContainer }
        foreach ($foundFile in $foundFiles) {
            try {
                Remove-Item -Path $foundFile.FullName -Force -ErrorAction Stop
            } catch {
                Write-Warning "Unable to delete file: $($foundFile.FullName). Error: $_"
            }
        }
    }
}

function DeleteWithRetries($path, $pattern) {
    $count = 0
    do {
        try {
            Get-ChildItem -Path $path -Filter $pattern -Recurse | Remove-Item -Force -ErrorAction Stop
            return
        } catch {
            Start-Sleep -Seconds 2
            $count++
        }
    } while ($count -lt $global:retryCount)
}

function UninstallWithRetries($uninstallPath) {
    $uninstallRetryCount = 0
    do {
        try {
            Start-Process $uninstallPath -ArgumentList "/S" -Wait -ErrorAction Stop
            Write-Host "Successfully uninstalled TeamViewer using path: $uninstallPath"
            return
        } catch {
            Write-Warning "Attempt to uninstall TeamViewer failed. Error: $_"
            Start-Sleep -Seconds 2
            $uninstallRetryCount++
        }
    } while ($uninstallRetryCount -lt $global:retryCount)
    Write-Warning "Failed to uninstall TeamViewer after multiple retries."
}

# Execution Starts Here
try {
    # Uninstall TeamViewer with retries
    foreach ($path in $teamViewerUninstallPaths) {
        if (Test-Path -Path $path) {
            UninstallWithRetries $path
        } else {
            Write-Host "Uninstaller not found at $path."
        }
    }

    # Delete TeamViewer executables
    DeleteFile "C:\Users" $fileNamePattern
    if (Test-Path -Path "D:\") {
        DeleteFile "D:\" $fileNamePattern
    }

    # Delete Shortcuts with Retry Logic
    foreach ($shortcutPath in $shortcutPaths) {
        DeleteWithRetries $shortcutPath "*TeamViewer*.lnk"
    }

    Write-Host "TeamViewer remediation process completed successfully."
    exit 0
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error "Error occurred: $errMsg"
    exit 1
}
