# Define the version to check
$targetVersion = "2024.12.0"

# Function to check installed applications
function Get-InstalledApplication {
    param (
        [string]$appName
    )
    $apps = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$appName*" }
    return $apps
}

# Check if RStudio is installed
$installedApps = Get-InstalledApplication -appName "RStudio"

# Check if the target version is installed
$installed = $false
foreach ($app in $installedApps) {
    if ($app.Version -eq $targetVersion) {
        $installed = $true
        break
    }
}

# Output the result
if ($installed) {
    Write-Output "RStudio version $targetVersion is installed."
} else {
    Write-Output "RStudio version $targetVersion is not installed."
}
