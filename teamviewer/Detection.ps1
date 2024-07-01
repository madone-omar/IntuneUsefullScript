# PowerShell Detection Script for TeamViewer

$installedSoftware = Get-ChildItem "HKLM:\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall", 
                                    "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall" -ErrorAction SilentlyContinue

# Checking if TeamViewer is in the list of installed software
$teamViewerFound = $false
foreach ($item in $installedSoftware) {
    $displayName = (Get-ItemProperty -Path $item.PSPath).DisplayName
    if ($displayName -like "*TeamViewer*") {
        $teamViewerFound = $true
        break
    }
}

# Output and exit codes based on the detection
if ($teamViewerFound) {
    $teamViewerStatus = "Detected"
    Write-Output ($teamViewerStatus | ConvertTo-Json -Compress)
    Exit 1  # Exit with code 1, indicating TeamViewer is detected
} else {
    $teamViewerStatus = "Not Detected"
    Write-Output ($teamViewerStatus | ConvertTo-Json -Compress)
    Exit 0  # Exit with code 0, indicating TeamViewer is not detected
}
