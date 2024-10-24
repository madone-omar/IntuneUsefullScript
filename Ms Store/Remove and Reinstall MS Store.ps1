<#
.SYNOPSIS
    This script checks if the system meets the requirements for BitLocker silent encryption, including TPM version 2.0, UEFI boot mode, and Secure Boot status.

.DESCRIPTION
    The script performs a series of checks to validate that the system is equipped for BitLocker silent encryption. It checks:
    - TPM (Trusted Platform Module) availability and version (requires version 2.0 or higher).
    - UEFI firmware mode, ensuring the system is not in Legacy BIOS mode.
    - Secure Boot status, verifying if Secure Boot is enabled.

    If any of these requirements are not met, the script provides guidance for remediation.

.NOTES
    Author: Omar Osman Mahat
    Twitter: https://x.com/thekingsmakers

.PARAMETER None
    This script does not accept any parameters.

.EXAMPLE
    Run the script to check if the system is BitLocker ready:
    
    ```powershell
    .\Remove and Reinstall MS Store.ps1
    ```

.OUTPUTS
    Exit code 0: All requirements are met.
    Exit code 1: One or more requirements are not met.

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
