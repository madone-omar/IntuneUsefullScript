# Uninstall Snip & Sketch using winget
try {
    winget uninstall --id "Microsoft.ScreenSketch_8wekyb3d8bbwe" --silent
    Write-Host "Uninstallation completed successfully."
}
catch {
    Write-Host "An error occurred during the uninstallation."
    Exit 1
}
