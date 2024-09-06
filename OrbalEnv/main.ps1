#Requires -Version 7.0

# ************************************************* #
# Source all the Plugins for the Orbal Environment! #
# ************************************************* #

$mainScriptDir = $PSScriptRoot
$pluginEntries = (Get-ChildItem -Path $mainScriptDir `
                                -Include '*.ps1'     `
                                -Exclude 'main.ps1'  `
                                -Recurse -Depth 1)

foreach ($script in $pluginEntries)
{
    Write-Host "`nSourcing $script...`n"
    . $script
}
