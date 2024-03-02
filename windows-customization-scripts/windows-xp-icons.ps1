#Requires -RunAsAdministrator

Param(
    [string]$xpSystemIcons = "",
    [string]$xpProgramIcons = ""
)

# Little script to change all the icons we can to their Windows XP counterparts :)
# The actual icon image files are saved in my Google Drive. This is only the script,
# which assumes we've downloaded them already and saved them to our computer we wish
# to customize.

function Create-KeyIfNotExists
{
}

# The way to change icons on Windows is via the Registry Editor. So, first, we
# have to make sure we are actually running on Windows, since Powershell is now
# multiplatform. If we're on Linux or Mac, then this script won't work and I don't
# want to find out whether it would break something lol.

if ($Env:OS -ine "Windows_NT")
{
    Write-Host "Apologies, but this script requires access to the Windows Registry."
    Write-Host "So, we can't run it here :("
    exit 0
}

# EXAMPLE FOR LATER

Write-Host "Fetching Discord Registry Properties..."
$props = Get-ItemProperty -Path "HKCU:\Software\Classes\Discord"

# This returns null.
Write-Host "`nFinding the Key Called 'Funny Item': "
Get-Member -InputObject $props -Name "Funny Item"

# This returns the value of the '(Default)' Key.
Write-Host "`nFinding the Key Called '(Default)': "
Get-Member -InputObject $props -Name "(Default)"

# This returns all the properties, some of which might look familiar to engineers :)
Write-Host "`nAll the Properties!"
Get-Member -InputObject $props
