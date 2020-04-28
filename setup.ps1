function Invoke-CommandRunAs
{
    <#
    .SYNOPSIS
        this is like sudo
    .DESCRIPTION
    #>
    [cmdletbinding()]
    [Alias("winsudo")]
    #管理者権限で開いたPowerShellでコマンドを実行
    $cd = (Get-Location).Path
    $commands = "Set-Location $cd; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

function UnixSetup {
    <#
    .SYNOPSIS
        Unix環境向けのセットアップスクリプトです。
    .DESCRIPTION
        This is setup for Unix Platform(ex: MacOS, Debian, etc..)
        In Unix Platform, The profile and modules path is different from Windows Platform.
        https://docs.microsoft.com/ja-jp/powershell/scripting/whats-new/what-s-new-in-powershell-core-60?view=powershell-6
    #>
    #$UserPrifileDir = "~/.config/powershell/"
    $UserModuleDir = "~/.local/share/powershell/"
    #$HistoryFile = "~/.local/share/powershell/PSReadline/ConsoleHost_history.txt"
    Write-Output "Setup for unix..."

    #Make symboriclink to profile
    #mkdir -p ($PROFILE -replace "/Microsoft.PowerShell_profile.ps", "")
    New-Item -Value "./Microsoft.PowerShell_profile.ps1" -Path ($PROFILE -replace "/Microsoft.PowerShell_profile.ps1", "") -Name "Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Force
    New-Item -Value "./RepoList.ps1" -Path ($PROFILE -replace "/Microsoft.PowerShell_profile.ps", "") -Name "RepoList.ps1" -ItemType SymbolicLink -Force
    Write-Output "profile link... done."

    #Make symboriclink to Modules
    #mkdir -p ($UserModuleDir -replace "/Modules", "")
    New-Item -Value './Modules' -Path $UserModuleDir -Name 'Modules' -ItemType SymbolicLink -Force
    #ln -s ./Modules $UserModuleDir
    Write-Output "Modules Dir copy... done."
}

function WindowsSetup{
    <#
    .SYNOPSIS
        Windows環境向けのセットアップスクリプトです。
    .DESCRIPTION
        This is setup for Windows Platform.
    #>
    Write-Output "Setup for Windows..."
    $profileDir = $PROFILE -replace "WindowsPowerShell\\.*$",""
    #make symbolicLink
    sudo New-Item -Value '../wps' -Path $profileDir -Name 'WindowsPowerShell' -ItemType SymbolicLink

    Write-Output "Make SymbolicLink WindowsPowerShell... done!"

}

#isMainModule
switch ($PSVersionTable.Platform) {
    "Unix" { UnixSetup; break }
    "Win32NT" {WindowsSetup; break}
    "" {WindowsSetup; break}
    default { Write-Warning "Platform is Unknown. You need check $PSVersionTables.Platform that It's  Unix or windows." }
}
