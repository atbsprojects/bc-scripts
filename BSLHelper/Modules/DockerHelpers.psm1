function Get-IsDockerInstalled {
    try {
        docker info 2> $null | Out-Null

        if ($LastExitCode -eq 0) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

function Get-DoesContainerExist {
    param(
        [string]$ContainerName
    )
    try {
        docker inspect $ContainerName 2>$null | Out-Null

        if ($LastExitCode -eq 0) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

Export-ModuleMember -Function Get-IsDockerInstalled, Get-DoesContainerExist