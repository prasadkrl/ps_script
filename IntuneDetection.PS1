#Author Prasad_APR 2025
# works if Powershell CLM enabled
# Variables
$r = '\d+(?:[-_.]\d+){0,3}'
$t = 'SilentlyContinue'
$z = 'Java 8 Update*'
$o = 'Detected'
$d = '8.0.4210.9'
$l = "$env:ProgramData\PatchMyPCIntuneLogs\PatchMyPC-SoftwareDetectionScript.log"

# Function to log messages
function l {
    param (
        [string]$h,
        [bool]$f,
        [string]$s
    )

    $p = "$env:Temp\PatchMyPC-SoftwareDetectionScript.log"
    
    # Check log file size and rotate if necessary
    if ((Get-Item $p -ErrorAction $t).Length -ge 5MB) {
        Remove-Item ($p.Replace('.log', '.lo_')) -Force -ErrorAction $t
        Rename-Item $p ($p.Replace('.log', '.lo_'))
    }

    "$((Get-Date)) ~ [$s] ~ [Found: $f] ~ [Purpose: Detection] ~ [Context: $env:USERNAME] ~ [Hive: $h]" | Out-File $p -Append -Force
}

# Function to parse version numbers
function c {
    param (
        [string]$s
    )

    # Check if the version has fewer than 4 parts and pad it
    $sParts = $s.Split('.')
    if ($sParts.Count -lt 4) {
        $s += '.0' * (4 - $sParts.Count)
    }

    # Try converting to a version, if fails, return a default version (0.0.0.0)
    try {
        [version]$s
    } catch {
        '0.0.0.0'
    }
}

# Function to detect installed software
function detect-software {
    foreach ($hive in 'HKLM') {
        foreach ($key in @('SOFTWARE', 'SOFTWARE\WOW6432Node')) {
            $path = "$hive\$key\Microsoft\Windows\CurrentVersion\Uninstall\*"
            $uninstallKeys = Get-ItemProperty -Path $path -ErrorAction $t
            
            foreach ($entry in $uninstallKeys) {
                $displayName = $entry.DisplayName
                $displayVersion = $entry.DisplayVersion
                $parsedVersion = $displayVersion -replace $r

                if ($displayName -like $z -or $displayName -match $u -and $u -ne '') {
                    if ($parsedVersion -ge (c $d)) {
                        l $hive $true "$displayName found with version $parsedVersion"
                        return $o
                    }
                }
            }
        }
    }

    # Log that detection failed
    l '' $false "$z not found"
}

# Run detection
detect-software
