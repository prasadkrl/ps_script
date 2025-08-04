# Uninstall Script for Splashtop Streamer
# Author *****PC*****Date 29 NOV 2024
# Works with PowerShell Constrained Language Mode (CLM)

# Variables
$OldAppName = "Splashtop Streamer"
$OldAppVersion = "3.7.0.1"
$RegistryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Search for the application in the registry
foreach ($RegistryPath in $RegistryPaths) {
    $UninstallKey = Get-ChildItem -Path $RegistryPath -ErrorAction SilentlyContinue | Where-Object {
        ($_.PSChildName -match "^\{.*\}$") -and
        ((Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue).DisplayName -eq $OldAppName) -and
        ((Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue).DisplayVersion -eq $OldAppVersion)
    }

    if ($UninstallKey) {
        # Extract the UninstallString
        $UninstallString = (Get-ItemProperty -Path $UninstallKey.PSPath).UninstallString

        # Modify the UninstallString for silent uninstall, if necessary
        if ($UninstallString -match "msiexec\.exe") {
            $UninstallString = "$UninstallString /quiet /norestart"
        }

        Write-Output "Found $OldAppName version $OldAppVersion. Attempting to uninstall..."
        
        # Invoke the uninstallation using cmd.exe to comply with CLM restrictions
        cmd.exe /c $UninstallString
        Write-Output "Uninstall process completed."

        # Exit after uninstalling
        break
    }
}

# If no matching application is found
if (-not $UninstallKey) {
    Write-Output "$OldAppName version $OldAppVersion not found. Nothing to uninstall."
}
