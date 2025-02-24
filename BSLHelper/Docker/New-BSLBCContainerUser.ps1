$ModulesPath = Split-Path -Parent $MyInvocation.MyCommand.Definition | Split-Path -Parent

Import-Module "$ModulesPath\Modules\InputHelpers.psm1"
Import-Module "$ModulesPath\Modules\LanguageHelpers.psm1"
Import-Module "$ModulesPath\Modules\NetworkHelpers.psm1"
Import-Module "$ModulesPath\Modules\DockerHelpers.psm1"

function Remove-BcContainerBcUser() {
    param(
        [string] $containerName,
        [string] $serverInstance,
        [string] $tenant = "default",
        [string] $userName
    )

    if ([string]::IsNullOrEmpty($containerName)) {
        Write-Error "Container name cannot be null or empty."
        return
    }
    if ([string]::IsNullOrEmpty($serverInstance)) {
        Write-Error "Server instance cannot be null or empty."
        return
    }
    if ([string]::IsNullOrEmpty($userName)) {
        Write-Error "User name cannot be null or empty."
        return
    }

    try {
        docker exec -it $containerName powershell -Command "Import-Module 'C:\Program Files\Microsoft Dynamics NAV\240\Service\NavAdminTool.ps1'; Remove-NAVServerUser -ServerInstance $serverInstance -UserName $userName -tenant $tenant;"
    }
    catch {
        
    }
}

function New-BSLBCContainerUser() {
    Initialize-Language

    $container_name = Get-ParsedInput -prompt "Enter container name"

    $is_docker_installed = Get-IsDockerInstalled

    if (-not $is_docker_installed) {
        Write-Error "Docker is not installed, exiting ..."

        Exit 1
    }

    $does_container_exist = Get-DoesContainerExist -ContainerName $container_name

    if (!$does_container_exist) {
        Write-Host "Container doesn't exist, exiting ..."

        Exit 1
    }

    $users = Get-BcContainerBcUser -containerName $container_name

    $container_info = Get-BcContainerServerConfiguration -containerName $container_name

    $number_of_users = $users.Count
    
    if ($number_of_users -ge 150) {
        $should_delete_user = Get-ParsedInputWithOptions -prompt "Do you want to delete a user? (y/n)" -options ("y", "n")

        if ($should_delete_user -eq "n") {
            Write-Host "Container already has maximum number of users, exiting ..." -ForegroundColor Red

            Exit 1
        }

        $should_keep_deleting = $True

        while ($should_keep_deleting) {
            $user_to_delete = $users | Select-Object -First 1

            $should_delete_the_user = Get-ParsedInputWithOptions -prompt "Do you want to delete user '$($user_to_delete.UserName)'? (y/n)" -options ("y", "n")

            if ($should_delete_the_user -eq "y") {
                Remove-BcContainerBcUser -serverInstance $container_info.ServerInstance -containerName $container_name -userName $user_to_delete.UserName
            }
            else {
                $should_keep_deleting = $False
            }
        }
    }

    # Ask if auth should be auth or password

    $credential = Get-Credential -Message 'Using UserPassword authentication. Please enter credentials for the container.'

    New-BcContainerBcUser -containerName $container_name -fullName super -PermissionSetId super -tenant default -Credential $credential
}

New-BSLBCContainerUser