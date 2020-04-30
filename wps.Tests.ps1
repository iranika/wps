# this script depend Pester.
param(
    [switch]$NoReloadModule
    ,$ModuleName = "wps"
)

. "$PSScriptRoot\wps.ps1"

if (!$NoReloadModule){
    # モジュールを再読み込みする
    Remove-Module $ModuleName -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Import-Module "$PSScriptRoot\." -WarningAction SilentlyContinue
}


Describe 'Test wps.ps1' {
    It "execute WpsUpdate"{
        Update-Wps
        $? | Should Be $true
    }
    #TODO: Add some tests.

}