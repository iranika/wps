# this script depend Pester.

. "$PSScriptRoot\wps.ps1"



Describe 'Test wps.ps1' {
    It "execute WpsUpdate"{
        Update-Wps
        $? | Should Be $true
    }
    #TODO: Add some tests.

}