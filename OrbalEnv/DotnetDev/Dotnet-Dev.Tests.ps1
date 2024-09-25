# File: Dotnet-Dev.Tests.ps1

# This little test script uses the Pester framework to conduct unit tests on
# the DotnetDev Environment.

$global:EnvScript = Join-Path $PSScriptRoot "dotnet-dev.ps1"
$global:DummyRepo = Join-Path $PSScriptRoot "Test-Dummy-Dir"
$global:ScriptExt = if ($IsWindows) { ".cmd" } else { ".sh" }
$global:TestFlagPrefix = if ($IsWindows) { "" } else { "-" }
$global:MainScriptPath = Join-Path $DummyRepo "build$ScriptExt"
$global:TestScriptPath = Join-Path $DummyRepo "src" "tests" "build$ScriptExt"

BeforeAll {
    . "$EnvScript"
    New-Item -Path "$DummyRepo" -ItemType "Directory"
    setrepo "$DummyRepo"
    whatifpreview
}

Describe 'Build-Repo Main' {
    Context 'Direct CLR Aliases' {
        It 'Build CLR as is' {
            $expected = $MainScriptPath       `
              + " -subset clr"                `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"     `
              + " -configuration $Env:DOTNET_DEV_CONFIG"

            buildclr 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Debug' {
            $expected = $MainScriptPath       `
              + " -subset clr"                `
              + " -configuration Debug"       `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildclrdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Checked' {
            $expected = $MainScriptPath       `
              + " -subset clr"                `
              + " -configuration Checked"     `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildclrchk 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Release' {
            $expected = $MainScriptPath       `
              + " -subset clr"                `
              + " -configuration Release"     `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildclrrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }

    Context 'Direct Libs Aliases' {
        It 'Build Libraries as is' {
            $expected = $MainScriptPath       `
              + " -subset libs"               `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"     `
              + " -configuration $Env:DOTNET_DEV_CONFIG"

            buildlibs 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build Libraries on Debug' {
            $expected = $MainScriptPath       `
              + " -subset libs"               `
              + " -configuration Debug"       `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildlibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build Libraries on Release' {
            $expected = $MainScriptPath       `
              + " -subset libs"               `
              + " -configuration Release"     `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildlibsrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }

    Context 'Direct CLR+Libs Aliases' {
        It 'Build CLR and Libraries as is' {
            $expected = $MainScriptPath       `
              + " -subset clr+libs"           `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"     `
              + " -configuration $Env:DOTNET_DEV_CONFIG"

            buildclrlibs 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR and Libraries on Debug' {
            $expected = $MainScriptPath       `
              + " -subset clr+libs"           `
              + " -configuration Debug"       `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildclrlibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR and Libraries on Release' {
            $expected = $MainScriptPath       `
              + " -subset clr+libs"           `
              + " -configuration Release"     `
              + " -arch $Env:DOTNET_DEV_ARCH" `
              + " -os $Env:DOTNET_DEV_OS"

            buildclrlibsrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }

    Context 'CLR+Libs Diff Configs Aliases' {
        It 'Build CLR on Checked and Libraries on Debug' {
            $expected = $MainScriptPath          `
              + " -subset clr+libs"              `
              + " -runtimeConfiguration Checked" `
              + " -librariesConfiguration Debug" `
              + " -arch $Env:DOTNET_DEV_ARCH"    `
              + " -os $Env:DOTNET_DEV_OS"        `
              + " -configuration Checked"

            buildclrlibschkdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Release and Libraries on Debug' {
            $expected = $MainScriptPath          `
              + " -subset clr+libs"              `
              + " -runtimeConfiguration Release" `
              + " -librariesConfiguration Debug" `
              + " -arch $Env:DOTNET_DEV_ARCH"    `
              + " -os $Env:DOTNET_DEV_OS"        `
              + " -configuration Release"

            buildclrlibsreldbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Debug and Libraries on Release' {
            $expected = $MainScriptPath            `
              + " -subset clr+libs"                `
              + " -runtimeConfiguration Debug"     `
              + " -librariesConfiguration Release" `
              + " -arch $Env:DOTNET_DEV_ARCH"      `
              + " -os $Env:DOTNET_DEV_OS"          `
              + " -configuration Debug"

            buildclrlibsdbgrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Build CLR on Checked and Libraries on Release' {
            $expected = $MainScriptPath            `
              + " -subset clr+libs"                `
              + " -runtimeConfiguration Checked"   `
              + " -librariesConfiguration Release" `
              + " -arch $Env:DOTNET_DEV_ARCH"      `
              + " -os $Env:DOTNET_DEV_OS"          `
              + " -configuration Checked"

            buildclrlibschkrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }
}

Describe 'Build-Repo Tests' {
    Context 'Core_Root with Release Libraries as Default' {
        It 'Generate Core_Root as is' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_CONFIG" `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Release"

            gencoreroot 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Debug' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Debug"                  `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Release"

            gencorerootdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Checked' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Checked"                `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Release"

            gencorerootchk 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Release' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Release"                `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Release"

            gencorerootrel 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }

    Context 'Core_Root with Debug Libraries' {
        It 'Generate Core_Root as is' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_CONFIG" `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Debug"

            gencorerootlibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Debug' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Debug"                  `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Debug"

            gencorerootdbglibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Checked' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Checked"                `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Debug"

            gencorerootchklibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }

        It 'Generate Core_Root on Release' {
            $expected = $TestScriptPath `
              + " ${TestFlagPrefix}Release"                `
              + " ${TestFlagPrefix}$Env:DOTNET_DEV_ARCH"   `
              + " ${TestFlagPrefix}os $Env:DOTNET_DEV_OS"  `
              + " ${TestFlagPrefix}GenerateLayoutOnly"     `
              + " /p:LibrariesConfiguration=Debug"

            gencorerootrellibsdbg 6>&1 | Tee-Object -Variable result
            $result[0] | Should -Be $expected
        }
    }
}

Describe 'Complex Command Lines' {
    It 'CLR+Libs x64,x86,Arm64 +Host All Platforms' {
        $expected = $MainScriptPath `
          + " -subset clr+libs+host"         `
          + " -configuration Release"        `
          + " -librariesConfiguration Debug" `
          + " -runtimeConfiguration Checked" `
          + " -arch x64,x86,arm64"           `
          + " -os $Env:DOTNET_DEV_OS"

        $devcmdline = "buildrepo main" `
          + " set=clr+libs"            `
          + " config=rel"              `
          + " lc=dbg"                  `
          + " runconfig=chk"           `
          + " arch=x64"                `
          + " arch=x86"                `
          + " -s host"                 `
          + " -a arm64"

        Invoke-Expression "$devcmdline" 6>&1 | Tee-Object -Variable result
        $result[0] | Should -Be $expected
    }

    It 'CLR Subsets with Libs x64,x86,Arm64 Obfuscated with Also Some MSBuild' {
        $expected = $MainScriptPath `
          + " -subset clr.runtime+clr.corelib+clr.nativecorelib+clr.tools+clr.alljits+libs+libs.tests" `
          + " -arch arm64,x64,x86"           `
          + " -configuration Release"        `
          + " -runtimeConfiguration Checked" `
          + " -test -bl"                     `
          + " -os $Env:DOTNET_DEV_OS"        `
          + " /p:NoPgo=true"                 `
          + " /p:UseCrossgen2=false"

        $devcmdline = "buildrepo main" `
          + " set=clr.runtime+clr.corelib+clr.nativecorelib+clr.tools" `
          + " arch=arm64"                     `
          + " config=Release"                 `
          + " subset=clr.alljits"             `
          + " -s libs+libs.tests"             `
          + " /p:NoPgo=true"                  `
          + " --runtimeConfiguration Checked" `
          + " /p:UseCrossgen2=false"          `
          + " --test"                         `
          + ' -arch "x64,x86"'                `
          + " -bl"

        Invoke-Expression "$devcmdline" 6>&1 | Tee-Object -Variable result
        $result[0] | Should -Be $expected
    }
}

AfterAll {
    Remove-Item -Path "$DummyRepo" -Recurse
}
