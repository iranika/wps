function RepoUpdate {
    param(
        # Parameter help description
        [Parameter(Mandatory)]$RepoList
        ,$ModulesParentDir = (Split-Path "$PSScriptRoot" -Parent)
    )
    $RepoList | % {
        try {
            $current = Get-Location
            $ModuleName = ($_ -replace ".git", "") -replace "^.*/",""
            $ModulePath = Join-Path $ModulesParentDir $ModuleName
            echo $ModulePath
            if (Test-Path $ModulePath){
                Set-Location $ModulePath
                git pull
            }else{
                Set-Location $ModulesParentDir
                git clone $_
            }    
        }
        finally {
            Set-Location $current            
        }
    }

}

function Update-Wps{
    <#
    .SYNOPSIS

    .DESCRIPTION
    
    .EXAMPLE
    
    .EXAMPLE
    
    #>
	[cmdletbinding()]
    [Alias("WpsUpdate")]
    param(
        [switch]$DayOnce
        ,$RepoListFile = "$PSScriptRoot\RepoList.json"
        ,$LastPullDateFile = "$ProfileDir\LastPullDate.dat"
    )
    if (!(Test-Path $RepoListFile)){
        Write-Warning "$RepoListFile is Not found."
        return
    }

    $RepoList = Get-Content $RepoListFile | ConvertFrom-Json
    $current = Get-Location    
    if ($DayOnce -eq $false){
        RepoUpdate $RepoList
    }else{
        if (!(Test-Path $LastPullDateFile)){ Write-Output "" > $LastPullDateFile }
        $last_pull_date = Get-Content $LastPullDateFile -Raw
        $today = Get-Date -Format "yyyyMMdd"
        if ($last_pull_date -ne $today){
            $today > $LastPullDateFile
            RepoUpdate $RepoList
        }
    }
    Set-Location $current
}

Export-ModuleMember -Alias *