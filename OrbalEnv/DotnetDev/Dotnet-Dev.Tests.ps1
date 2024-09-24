# File: Dotnet-Dev.Tests.ps1

# This little test script uses the Pester framework to conduct unit tests on
# the DotnetDev Environment.

$global:EnvScript = Join-Path $PSScriptRoot "dotnet-dev.ps1"
$global:DummyRepo = Join-Path $PSScriptRoot "Test-Dummy-Dir"

BeforeAll {
    . "$EnvScript"
    New-Item -Path "$DummyRepo" -ItemType "Directory"
    setrepo "$DummyRepo"
    whatifpreview
}

Describe 'Build-Repo Main' {
    Context 'Direct-Aliases' {
        It 'Build CLR as is' {
            $expected = (Join-Path $DummyRepo "build.sh") `
              + " -subset clr"                            `
              + " -arch $Env:DOTNET_DEV_ARCH"             `
              + " -os $Env:DOTNET_DEV_OS"                 `
              + " -configuration $Env:DOTNET_DEV_CONFIG"

            buildclr 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }
}

AfterAll {
    Remove-Item -Path "$DummyRepo" -Recurse
}
