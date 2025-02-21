$ModulesPath = Split-Path -Parent $MyInvocation.MyCommand.Definition | Split-Path -Parent

Import-Module "$ModulesPath\Modules\InputHelpers.psm1"
Import-Module "$ModulesPath\Modules\LanguageHelpers.psm1"
Import-Module "$ModulesPath\Modules\NetworkHelpers.psm1"
Import-Module "$ModulesPath\Modules\DockerHelpers.psm1"

function New-BSLBCContainerUser() {
    Initialize-Language

    $container_name = Get-ParsedInput -prompt "Enter container name"

    $is_docker_installed = Get-IsDockerInstalled

    if (-not $is_docker_installed) {
        Write-Host "Docker is not installed, exiting ..."

        Exit 1
    }

    $does_container_exist = Get-DoesContainerExist -ContainerName $container_name

    if (!$does_container_exist) {
        Write-Host "Container doesn't exist, exiting ..."

        Exit 1
    }

    $users = Get-BcContainerBcUser -containerName $container_name

    $number_of_users = $users.Count
    
    if ($number_of_users -ge 150) {
        Write-Host "Container already has maximum number of users, exiting ..."

        $should_delete_user = Get-ParsedInputWithOptions -prompt "Do you want to delete a user?" -options ("y", "n")

        if ($should_delete_user -eq "y") {
            $user_to_delete = Get-ParsedInput -prompt "Enter user name to delete"

            Remove-BcContainerBcUser -containerName $container_name -userName $user_to_delete
        }
    }

    # Ask if auth should be auth or password

    $credential = Get-Credential -Message 'Using UserPassword authentication. Please enter credentials for the container.'

    New-BcContainerBcUser -containerName $container_name -fullName super -PermissionSetId super -tenant default -Credential $credential
}

New-BSLBCContainerUser