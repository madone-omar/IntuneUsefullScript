<#
.SYNOPSIS
    this script will remove microsoft store and reinstall it with the updated version

.DESCRIPTION
   this script will remove microsoft store and reinstall it with the updated version

.NOTES
    Author: Omar Osman Mahat
    Twitter: https://x.com/thekingsmakers

.PARAMETER None
    This script does not accept any parameters.

.EXAMPLE
    Run the script to do as described:
    
    ```powershell
    .\Remove and Reinstall MS Store.ps1
    ```



.LINK
    https://x.com/thekingsmakers
#>


# Remove the Microsoft Store app for the current user silently
Get-AppxPackage -Name *store | Remove-AppxPackage -ErrorAction SilentlyContinue > $null 2>&1

# Reinstall the Microsoft Store app for all users silently
Get-AppxPackage -AllUsers Microsoft.WindowsStore | Foreach {
    Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue > $null 2>&1
}

# The script is silent, and no output or prompts will be shown
